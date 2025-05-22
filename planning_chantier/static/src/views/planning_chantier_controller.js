import { Component } from "@odoo/owl";
import { useModel } from "@web/views/view_hook";


console.log('PlanningChantierController');

export class PlanningChantierController extends Component {
    setup() {

        console.log('PlanningChantierController setup');


        this.model = useModel();
        this.model.loadData(); // Chargement initial



    }

    onSearch(searchQuery) {
        this.model.loadData(searchQuery);
    }
}

PlanningChantierController.template = "PlanningChantierRenderer";
PlanningChantierController.props = ["search"];
