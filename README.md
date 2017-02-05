# UIScript

A DSL for building UIs, with (currently/at least) a textual syntax.


## Installation

Import all projects, except for `uiscript-examples` into an Eclipse workspace.
After (clean-)building, there will likely be errors in the file `TypeExtensionsImpl.xtend` in the project `com.dslconsultancy.uiscript.core` under `src/com.dslconsultancy.uiscript.extensions.impl`.
(This seems to be due to a form of "deep cyclicity" that manages to stump Xtext/Xtend's build organisation.)
"Touch" that file by doing either of the following:

* Open `TypeExtensionsImpl.xtend`, type a character, delete it, and save.
* Execute `touch` on that file from the command-line + F5 in Eclipse to Refresh.

As soon as the workspace is error-free, you can start the `com.dslconsultancy.uiscript.xtext.ui` project as Eclipse Application.
In the 2nd Eclipse, import the `uiscript-examples` project for some examples.


## Code base organization

Currently, UIScript is based on EMF (specifically: Xcore and Xtend) and Xtext.
However, in the future we might provide an alternative implementation (!) based on projectional editing, running in the JavaScript ecology.

This repository contains a number of Eclipse projects which are at least compatible with:

* Java8
* Eclipse Neon.2 Release (4.6.2)
* Xtext (and Xtend) 2.11
* Xcore 1.4.0
* EMF 2.12.0

Everything but the first can be [downloaded here](http://www.eclipse.org/Xtext/download.html) as one install.

The Eclipse projects are:

* `com.dslconsultancy.uiscript.core`: contains the type definitions for the AST in Xcore, helper classes (to be used as `extension`s in Xtend) and maybe some (code) generation.
* `com.dslconsultancy.uiscript.xtext*`: the usual set of Xtext-related Eclipse projects.
* `uiscript-examples`: contains some example "prose" in UIScript-format.


### Tricks/patterns

At a number of places, implementations are explicitly separated from their interfaces using Google Guice's `@ImplementedBy` annotation.
This is done for pure compilation/build speed when working on the DSL, since it prevents a cascading compilation/build "in Xtend-space" when only internals of an implementation are being changed.
The drawback is the cyclic compile dependency (since both files refer the other).

In these cases, the interface resides in a file `TypeExtensions.java` that contains e.g.

```
@ImplementedBy(TypeExtensionsImpl.class)
public interface TypeExtensions {

	boolean isFooBar();	// (example!)

}
```
while the implementation resides in a file `TypeExtensionsImpl.xtend` that contains at least:

```
@Singleton
class TypeExtensionsImpl implements TypeExtensions {

	override isFooBar() { true }

}
```

