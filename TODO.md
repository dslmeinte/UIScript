# TODOs/Roadmap

Roughly in order of descending importance:

* Start out by generating React+MobX-based JavaScript (or even TypeScript!) code so it's easy to get things working, but move towards interpreting a model (preferably stored as a flat list of JSON objects) eventually.

* Check implementation, especially the grammar w.r.t. scoping (including its global configuration) and validation, for:

	* Comments up-to-date?
	* **TODO**s still relevant?
	* Implementation of outline.

* Small tweaks:

    * `screen` &rarr; `page`;
    * annotate a `goto-page` with an indication whether that transition is popping from or pushing to the history's stack;
    * `method` &rarr; `action`?;
    * give a `component` a "slot" (or even "slots") where you can plug in arbitrary contents?;
    * more hooks for styling?

* Bigger change: declare widgets (components?) in a sort of standard library, instead of making every widget part of the grammar.
 

## Architecture of generated app

Some requirements:

* Should not be opinionated about routing and authentication.
* Should have minimum interface to "wire in".
* Should be functionally callable.
* Relies on "ambient" app (supposedly minimal) to call generated code, and render into an HTML element.

Some mappings:

* `structure` &rarr; a class, with appropriate `@observable` annotations.
* `page` or `component` &rarr; a function taking an object which is a composition of the construct's arguments and its internal values (not invariants), and an interface definition for that object.

Some considerations:

* Use original names, not (generated) IDs.

