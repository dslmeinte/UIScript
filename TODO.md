# TODOs/Roadmap

Roughly in order of descending importance:

* Start out by generating React+MobX-based JavaScript (or even TypeScript!) code so it's easy to get things working, but move towards interpreting a model (preferably stored as a flat list of JSON objects).

* Check implementation, especially the grammar w.r.t. scoping (including its global configuration) and validation, for:

	* Comments up-to-date?
	* **TODO**s still relevant?

* Small tweaks:

    * `screen` &rarr; `page`;
    * annotate a `goto-page` with an indication whether that transition is popping from or pushing to the history's stack;
    * `method` &rarr; `action`?;
    * give a `component` a "slot" (or even "slots") where you can plug in arbitrary contents?;
    * more hooks for styling?

* Bigger change: declare widgets (components?) in a sort of standard library, instead of making every widget part of the grammar.
 
