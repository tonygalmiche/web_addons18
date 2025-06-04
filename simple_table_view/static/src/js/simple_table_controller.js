/** @odoo-module **/

import { Component } from "@odoo/owl";
import { Layout } from "@web/search/layout";

export class SimpleTableController extends Component {
    static template = "simple_table_view.SimpleTableController";
    static components = {
        Layout,
    };
    static props = {
        // Props essentiels utilisés
        resModel: String,
        Model: Function,
        Renderer: Function,
        domain: { type: Array, optional: true },
        selectRecord: { type: Function, optional: true },
        // Props optionnels mais ignorés
        info: { type: Object, optional: true },
        arch: { type: Object, optional: true },
        fields: { type: Object, optional: true },
        relatedModels: { type: Object, optional: true },
        useSampleModel: { type: Boolean, optional: true },
        createRecord: { type: Function, optional: true },
        limit: { type: Number, optional: true },
        noBreadcrumbs: { type: Boolean, optional: true },
        searchMenuTypes: { type: Array, optional: true },
        context: { type: Object, optional: true },
        groupBy: { type: Array, optional: true },
        orderBy: { type: Array, optional: true },
        comparison: { type: Object, optional: true },
        action: { type: Object, optional: true },
        className: { type: String, optional: true },
        display: { type: Object, optional: true },
        archInfo: { type: Object, optional: true },
        buttonTemplate: { type: String, optional: true },
    };

    setup() {
        this.model = new this.props.Model(this.env, {
            resModel: this.props.resModel,
        });


        if (!this.props.comparison) {
            this.props.comparison = {};
        }


    }




    async willStart() {
        await this.model.load({
            resModel: this.props.resModel,
            domain: this.props.domain || [],
        });
    }

    get className() {
        return `o_simple_table_view ${this.props.className || ""}`;
    }

    get display() {
        return {
            controlPanel: {},
            ...this.props.display,
        };
    }

    async onRecordClick(record) {
        if (this.props.selectRecord) {
            this.props.selectRecord(record.id);
        }
    }
}