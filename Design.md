# Design of UIScript language

UIScript is a way to produce UIs quickly and distraction-free.
It's opinionated in the way it lets you write reactive UIs, but quite unopinionated on how these should be run.

It's envisioned as a relatively thin abstraction of React, using (some patterns from) [MobX](http://mobxjs.github.io/mobx/).


## Fundamentals

We have the following fundamental concepts:

* **Structures** specify how data is layed out.
* **Services** specify how data is communicated with a(ny) backend.
* **Components** specify how to render data.
* **Expressions** are used to...ehm...be expressive, I guess ;) Oh, and you will use them everywhere!

Note that there's no CSS: UIScript only references CSS through class names but has no syntax for actually doing CSS.
There are a number of reasons for that:

* CSS is *large*, and I'd rather spend effort on providing the other concepts to the max than on taking ages to get to any level of completeness with respect to CSS.
* There are plenty of tools for authoring high-quality CSS, e.g. 

UIScript is statically-typed at compile time, but at runtime it does something I call "nothing semantics" and which is specified in the "Expressions" section.
It also does a lot of type inference, with as highlight the fact that literals for lists, arrays, dictionaries, maps, objects are essentially indistinguishable and syntactically the same as grouping in expressions!


### Syntax

For the whole language, the following legenda applies for "pairs of things":

* `{}` imply: grouping stuff (including in expressions!);
* `()` imply: something with either parameters/arguments (i.e., invocation);
* `<>` imply: something with HTML;
* `[]` imply: something with closures/lambdas/things that enjoy a certain kind of "delayed evaluation".

I abhor *separators* (especially of the `;` kind) because they form an impedement to changing the order in lists and such.
Also, it's a holdover from earlier times when parsers needed some help due to low memory and speed conditions.

However, to humour people for which they are simply a necessity of life (hateful or not), you can use a comma `,` to separate things.
5...ehm...using semicolons is all out!
Separating a thing from nothing is completely legal (to make swapping stuff around a bit easier), so the following is valid syntax to define a list of the first three positive integers:

```{ 1, 2,,, 3, }```

Yes, a list literal is written using `{}`: grouping things, eh?
But you could just as well write the same as `{ 1 2 3 }`.

An expression grouping is disambiguated from a list literal through context.
E.g., `{ 1 + 2 }` can either be a list literal or the value `3`, but in the context of `{ 1 + 2 } + 3` it must evidently be grouping.

In general, the syntax is a tad on the opinionated side and aims to concurrently make more sense than usual (e.g., by being more consistent than happens in typical GPLs), provide some convenience specifically for the UI world, as well as kick some shins.
So, be prepared to leave your comfort zone and enter the Twilight Zone ;)


## Structures

Types come in a number of flavours:

* *Structures* and *enumerations* are defined by you and are essentially equivalent to the classes and enumerations that you know from every mainstream language with a bit of Object Orientation.
* *Builtin types* are the basic types like <tt>String</tt>, <tt>Boolean</tt>, etc. which you can use to build structures with.


## Services

You can *declare* services which you then can call from your UI.
There's no way to define/implement these in UIScript, but fret not: plenty of existing solutions will help you with that - Swagger, Kirra, etc.

**TODO**  come up with actual syntax


## Components

This is the crux of UIScript: components allow you to visualise data, define behaviour, and tie this in to a style (through CSS).

UIScript components are essentially parametrised pieces of HTML markup that can be called/embedded anywhere.
UIScript does not talk about *properties versus state* of a component: the component has a number of parameters and some *local state*.
UIScript components map to React components in a way that plays ball with MobX, which ensures that you can think of your UI as a *function* of all application state (including state that only "lives" on a particular client and is nowhere persisted, such as whether a section has been collapsed).


### Syntax

A component looks syntactically as follows:

```
component TodoComponent(todos: Todo[]) {

	state {
		newTodo: Todo := new Todo
		todosCompleted == todos.filter[completed].count
		isNewTodoAddable == !newTodo.task.empty
	}

	actions {
		addTodo: { todos += newTodo, newTodo <- new Todo }
	}

	// body starts here:
	<div .{todoComponent} /> {
		todos.map[
			// ...
		]
	}

}
```

The `state` section defines "local state", i.e. state that's not passed explicitly to the component, is not persisted and only exists on the client visualising the component, as well as values computed from any state, i.e.: arguments passed or values from the local state.

The `actions` section defines actions that can be triggered by UI events.

The body section has no explicit starting/ending syntax: it just occupies the rest of the component.
It has to consist of a *single* tag construct, though.
(This is obviously a holdover from React, or rather: the JSX syntax.)


### The "tag" construct

The "tag" constructs either creates a HTML element or invokes a defined component.
(You can think of HTML elements as built-in components, if you so wish.)
The syntax is as follows: "`<`*tag-name*` .`*CSS-class-spec* `#`*ID-spec* *dictionary of attributes*`>` `{` *contents* `}`".

Example:
```
<TodoComponent .{myTodoApp [active]} todos: myTodos /> {}
```

The *tag name* is either the name of a HTML element (compliant with React), or the name of a defined component.

Following the tag name, there's an optional CSS class specification.
**TODO**
The name of a CSS class must be a valid identifier for JavaScript, so `my-class` is all out, I'm afraid.

Following either the tag name or a CSS class specification, there's an ID specification, which must be a valid JavaScript identifier.
This feature serves to cater for "old skool" CSS.

Whitespace between the tag name, the CSS class and ID specification is optional, and CSS class and ID specifications can be in any order.

After that, a dictionary of named argument values follows.
If the value of an argument "emits" a name matching an argument name (such as `todos`), then you can omit the argument's name.
So, `:todos` acts as shorthand for `todos: todos`.

The actual contents follow between `{}`.


## Expressions

Expressions in UIScript are mostly the same as in other languages, with a few notable differences and additions (which might even be construed as improvements/enhancements!).

First of all, grouping is done everywhere using curly braces `{}`, so also in expressions.
This allows you to visually distinguish function invocation from the completely different act of grouping stuff, either to thwart operator precedence, or improve readability, or both.

Second of all, UIScript come with a few abnormal operators, primarily to make it easy to write components.
These new operators are described below.

Thirdly, expressions are *everywhere* in UIScript, or put the other way around: almost everything is an expression, and if it isn't, it's a definition of something that can be called/invoked (with-)in an expression.
In particular, markup is a function although it has a syntax that's serves to separate it from regular function invocation.


### Nothing semantics

Fourthly (yes, this is starting to become quite dubitable...), evaluation of expressions has something that I like to call "nothing semantics".
All types implicitly have a possible value of **nothing**, although you can't write it, compare explicitly with it, etc.
By default, a nothing value bubbles up through the evaluation of any expression to produce a value that's in some way "sensible" in that context - which could even be nothing again.
This avoids the usual litany of comparisons with `undefined`, `null`, etc., as well as the usual problems with truthy vs. falsy values that plague JavaScript.


### The "when" operator

The "when" operator embodies the idea of "**if** this **then** something (**else** *nothing*)".

Suppose you want to visualise a button only if a certain condition `fooBarred` equals `true`.
In UIScript you express this (within the body of a component) as follows:

```
fooBarred -> <button .{warning explosive}> { "Proceed with caution?" }
```

You could view the "when" operator as a ternary **if**-operator that's been made binary again.


## TODOs

Not yet specification for/(much) thought given to:

* Modularisation and namespacing.
* Maybe have some syntax to reference/validate against CSS Modules defined in `.css`/`.scss` files?
	It seems to be rather easy to do this and provide plenty of value.
* The exact nature of the services' declarations.
* Consider adding explicit component syntax for dependency injection that maps to `<Provider...>`.

