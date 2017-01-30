# UIScript

A DSL for building UIs, with (currently/at least) a textual syntax.


## Code base organization

Currently, UIScript is based on EMF (specifically: Xcore and Xtend) and Xtext.
However, in the future we might provide an alternative implementation (!) based on projectional editing, running in the JavaScript ecology.

This repository contains a number of Eclipse projects which are at least compatible with:

* Java8
* Eclipse Neon.2 Release (4.6.2)
* Xtext (and Xtend) 2.10

The later two can be [downloaded here](http://www.eclipse.org/Xtext/download.html).

The Eclipse projects are:

* `com.dslconsultancy.uiscript.core`: contains the type definitions for the AST in Xcore, helper classes (to be used as `extension`s in Xtend) and maybe some (code) generation.


### Tricks/patterns

At a number of places, implementations are explicitly separated from their interfaces using Google Guice's `@ImplementedBy` annotation.
This is done for pure compilation/build speed when working on the DSL, since it prevents a cascading compilation/build "in Xtend-space" when only internals of an implementation are being changed.
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

