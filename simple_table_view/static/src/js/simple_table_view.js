/** @odoo-module **/

import { registry } from "@web/core/registry";
import { SimpleTableController } from "./simple_table_controller";
import { SimpleTableRenderer } from "./simple_table_renderer";
import { SimpleTableModel } from "./simple_table_model";

export const simpleTableView = {
    type: "simple_table",
    display_name: "Simple Table",
    icon: "oi oi-view-list",
    multiRecord: true,
    Controller: SimpleTableController,
    Renderer: SimpleTableRenderer,
    Model: SimpleTableModel,
    
    props: (genericProps, view, config) => {
        return {
            // Props utilisés par le Controller
            resModel: genericProps.resModel,
            Model: SimpleTableModel,
            Renderer: SimpleTableRenderer,
            domain: genericProps.domain,
            selectRecord: genericProps.selectRecord,
            
            // Props passés mais non utilisés (pour éviter les erreurs)
            info: genericProps.info,
            arch: genericProps.arch,
            fields: genericProps.fields,
            relatedModels: genericProps.relatedModels,
            useSampleModel: genericProps.useSampleModel,
            createRecord: genericProps.createRecord,
            limit: genericProps.limit,
            noBreadcrumbs: genericProps.noBreadcrumbs,
            searchMenuTypes: genericProps.searchMenuTypes,
            context: genericProps.context,
            groupBy: genericProps.groupBy,
            orderBy: genericProps.orderBy,
            //comparison: genericProps.comparison ,

            comparison: genericProps.comparison || {},

            action: config.actionId ? { id: config.actionId } : {},
            className: genericProps.className,
            display: genericProps.display || { controlPanel: {} },
            archInfo: genericProps.arch,
            buttonTemplate: genericProps.buttonTemplate,
        };
    },
};

registry.category("views").add("simple_table", simpleTableView);