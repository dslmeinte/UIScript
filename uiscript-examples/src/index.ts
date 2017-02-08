import {render} from "react-dom";

import * as todoApp from "../src-gen/todo-app";


render(
    todoApp.screen1(),
    document.getElementById("root")
);

