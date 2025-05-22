
import { registry } from "@web/core/registry";
import { PlanningChantierController } from "./planning_chantier_controller";
import { PlanningChantierRenderer } from "./planning_chantier_renderer";
import { PlanningChantierModel } from "./planning_chantier_model";

console.log('planningChantierView');



export const planningChantierView = {
    type: "planning_chantier",
    display_name: "Planning Chantier",
    icon: "fa-calendar",
    multiRecord: true,
    searchMenuTypes: ["filter", "favorite"],
    archParsePostProcessing(view) {
        view.withSearchBar = true; // Activer la barre de recherche
    },
    components: {
        Controller: PlanningChantierController,
        Renderer: PlanningChantierRenderer,
        Model: PlanningChantierModel,
    },
};



registry.category("views").add("planning_chantier", planningChantierView);


console.log('planningChantierView : registry.category("views")=',registry.category("views"));
