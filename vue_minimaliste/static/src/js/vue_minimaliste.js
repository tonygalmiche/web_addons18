/** @odoo-module **/

import { registry } from "@web/core/registry";
import { useService } from "@web/core/utils/hooks";
import { Component, useState, onWillStart } from "@odoo/owl";

export class VueMinimalisteController extends Component {
    setup() {
        this.orm = useService("orm");
        this.state = useState({
            records: [],
            isLoading: true,
        });

        onWillStart(async () => {
            await this.loadRecords();
        });
    }

    async loadRecords() {
        this.state.isLoading = true;
        try {
            const records = await this.orm.searchRead(
                this.props.resModel,
                this.props.domain || [],
                ["id", "name"],
                {
                    limit: this.props.limit || 80,
                    order: "id desc",
                }
            );
            this.state.records = records;
        } catch (error) {
            console.error("Erreur lors du chargement des enregistrements:", error);
        } finally {
            this.state.isLoading = false;
        }
    }

    async onRecordClick(recordId) {
        this.env.services.action.doAction({
            type: 'ir.actions.act_window',
            res_model: this.props.resModel,
            res_id: recordId,
            views: [[false, 'form']],
            target: 'current',
        });
    }
}

VueMinimalisteController.template = "vue_minimaliste.VueMinimaliste";

registry.category("views").add("vue_minimaliste", {
    type: "vue_minimaliste",
    display_name: "Vue Minimaliste",
    icon: "fa fa-th-list",
    multiRecord: true,
    Controller: VueMinimalisteController,
});
