/** @odoo-module **/

import { Component } from "@odoo/owl";

export class SimpleTableRenderer extends Component {
    static template = "simple_table_view.SimpleTableRenderer";
    static props = {
        // Props essentiels utilisés
        model: Object,
        onRecordClick: Function,
        // Props optionnels mais ignorés
        archInfo: { type: Object, optional: true },
    };

    get records() {
        return this.props.model.getRecords();
    }

    onRowClick(record) {
        this.props.onRecordClick(record);
    }
}