#!/bin/bash

# Script pour créer le module Odoo 18 Simple Table View
# Usage: ./create_simple_table_module.sh [chemin_vers_addons]

# Définir le chemin de base (par défaut current directory)
BASE_PATH=${1:-$(pwd)}
MODULE_PATH="$BASE_PATH/simple_table_view"

echo "Création du module Simple Table View dans: $MODULE_PATH"

# Créer la structure des dossiers
mkdir -p "$MODULE_PATH"
mkdir -p "$MODULE_PATH/models"
mkdir -p "$MODULE_PATH/static/src/js"
mkdir -p "$MODULE_PATH/static/src/xml"
mkdir -p "$MODULE_PATH/views"
mkdir -p "$MODULE_PATH/security"

# Créer __manifest__.py
cat > "$MODULE_PATH/__manifest__.py" << 'EOF'
{
    'name': 'Simple Table View',
    'version': '18.0.1.0.0',
    'category': 'Tools',
    'summary': 'Adds a new simple table view type',
    'description': """
        This module adds a new view type 'simple_table' that displays
        a simple table with ID and Name columns for any model.
    """,
    'author': 'Your Company',
    'website': 'https://www.yourcompany.com',
    'depends': ['base', 'web'],
    'data': [
        'security/ir.model.access.csv',
        'views/partner_views.xml',
    ],
    'assets': {
        'web.assets_backend': [
            'simple_table_view/static/src/js/simple_table_model.js',
            'simple_table_view/static/src/js/simple_table_controller.js',
            'simple_table_view/static/src/js/simple_table_renderer.js',
            'simple_table_view/static/src/js/simple_table_view.js',
            'simple_table_view/static/src/xml/simple_table_view.xml',
        ],
    },
    'installable': True,
    'application': False,
    'auto_install': False,
}
EOF

# Créer __init__.py (racine)
cat > "$MODULE_PATH/__init__.py" << 'EOF'
from . import models
EOF

# Créer models/__init__.py
cat > "$MODULE_PATH/models/__init__.py" << 'EOF'
from . import ir_ui_view
EOF

# Créer models/ir_ui_view.py
cat > "$MODULE_PATH/models/ir_ui_view.py" << 'EOF'
from odoo import models, fields

class IrUiView(models.Model):
    _inherit = 'ir.ui.view'
    
    type = fields.Selection(selection_add=[('simple_table', 'Simple Table')], ondelete={'simple_table': 'cascade'})
EOF

# Créer security/ir.model.access.csv
cat > "$MODULE_PATH/security/ir.model.access.csv" << 'EOF'
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_res_partner_simple_table,res.partner simple table,base.model_res_partner,base.group_user,1,1,1,1
EOF

# Créer views/partner_views.xml
cat > "$MODULE_PATH/views/partner_views.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Vue Simple Table pour les Partners -->
    <record id="view_partner_simple_table" model="ir.ui.view">
        <field name="name">res.partner.simple.table</field>
        <field name="model">res.partner</field>
        <field name="type">simple_table</field>
        <field name="arch" type="xml">
            <simple_table>
                <field name="id"/>
                <field name="name"/>
            </simple_table>
        </field>
    </record>

    <!-- Action pour afficher les partners avec la nouvelle vue -->
    <record id="action_partner_simple_table" model="ir.actions.act_window">
        <field name="name">Partners (Simple Table)</field>
        <field name="res_model">res.partner</field>
        <field name="view_mode">simple_table,list,form</field>
        <field name="view_ids" eval="[(5, 0, 0),
                                      (0, 0, {'view_mode': 'simple_table', 'view_id': ref('view_partner_simple_table')}),
                                      (0, 0, {'view_mode': 'list'}),
                                      (0, 0, {'view_mode': 'form'})]"/>
    </record>

    <!-- Menu pour accéder aux partners -->
    <menuitem id="menu_partner_simple_table"
              name="Partners Simple Table"
              parent="base.menu_base_partner"
              action="action_partner_simple_table"
              sequence="10"/>
</odoo>
EOF

# Créer static/src/js/simple_table_model.js
cat > "$MODULE_PATH/static/src/js/simple_table_model.js" << 'EOF'
/** @odoo-module **/

import { Model } from "@web/model/model";

export class SimpleTableModel extends Model {
    static services = ["orm"];

    setup() {
        this.orm = this.env.services.orm;
        this.records = [];
        this.count = 0;
    }

    async load(params = {}) {
        const { resModel, fields, domain = [], limit = 80, offset = 0 } = params;
        this.resModel = resModel;
        this.fields = fields;
        this.domain = domain;
        this.limit = limit;
        this.offset = offset;

        // Charger les enregistrements
        const records = await this.orm.searchRead(
            this.resModel,
            this.domain,
            ["id", "name"],
            {
                limit: this.limit,
                offset: this.offset,
            }
        );

        // Compter le total
        const count = await this.orm.searchCount(this.resModel, this.domain);

        this.records = records;
        this.count = count;

        return {
            records: this.records,
            count: this.count,
        };
    }

    async reload() {
        return this.load({
            resModel: this.resModel,
            fields: this.fields,
            domain: this.domain,
            limit: this.limit,
            offset: this.offset,
        });
    }

    getRecords() {
        return this.records;
    }

    getCount() {
        return this.count;
    }
}
EOF

# Créer static/src/js/simple_table_controller.js
cat > "$MODULE_PATH/static/src/js/simple_table_controller.js" << 'EOF'
/** @odoo-module **/

import { Component } from "@odoo/owl";
import { standardActionServiceProps } from "@web/webclient/actions/action_service";
import { Layout } from "@web/search/layout";
import { usePager } from "@web/search/pager_hook";
import { useSearchBarToggler } from "@web/search/search_bar_menu";

export class SimpleTableController extends Component {
    static template = "simple_table_view.SimpleTableController";
    static components = {
        Layout,
    };
    static props = {
        ...standardActionServiceProps,
        Model: Function,
        Renderer: Function,
        archInfo: Object,
        buttonTemplate: String,
        className: { type: String, optional: true },
        display: Object,
        resModel: String,
    };

    setup() {
        this.model = new this.props.Model(this.env, {
            resModel: this.props.resModel,
        });
        
        this.searchBarToggler = useSearchBarToggler();
        
        this.pager = usePager({
            offset: 0,
            limit: 80,
            total: 0,
            onUpdate: async ({ offset, limit }) => {
                await this.model.load({
                    resModel: this.props.resModel,
                    offset,
                    limit,
                });
                this.render();
            },
        });
    }

    async willStart() {
        const result = await this.model.load({
            resModel: this.props.resModel,
        });
        this.pager.updateState({ total: result.count });
    }

    get className() {
        return `o_simple_table_view ${this.props.className || ""}`;
    }

    get display() {
        return {
            controlPanel: {
                "top-right": false,
                "bottom-right": false,
            },
            ...this.props.display,
        };
    }

    async onRecordClick(record) {
        this.props.selectRecord(record.id);
    }
}
EOF

# Créer static/src/js/simple_table_renderer.js
cat > "$MODULE_PATH/static/src/js/simple_table_renderer.js" << 'EOF'
/** @odoo-module **/

import { Component } from "@odoo/owl";

export class SimpleTableRenderer extends Component {
    static template = "simple_table_view.SimpleTableRenderer";
    static props = {
        model: Object,
        archInfo: Object,
        onRecordClick: Function,
    };

    get records() {
        return this.props.model.getRecords();
    }

    onRowClick(record) {
        this.props.onRecordClick(record);
    }
}
EOF

# Créer static/src/js/simple_table_view.js
cat > "$MODULE_PATH/static/src/js/simple_table_view.js" << 'EOF'
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
        const { arch, fields, resModel } = genericProps;
        const archInfo = arch;
        
        return {
            ...genericProps,
            Model: SimpleTableModel,
            Renderer: SimpleTableRenderer,
            buttonTemplate: "simple_table_view.SimpleTableButtons",
            archInfo,
        };
    },
};

registry.category("views").add("simple_table", simpleTableView);
EOF

# Créer static/src/xml/simple_table_view.xml
cat > "$MODULE_PATH/static/src/xml/simple_table_view.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<templates xml:space="preserve">
    
    <t t-name="simple_table_view.SimpleTableController" owl="1">
        <Layout display="display" className="className">
            <t t-component="props.Renderer" 
               model="model" 
               archInfo="props.archInfo"
               onRecordClick.bind="onRecordClick"/>
        </Layout>
    </t>

    <t t-name="simple_table_view.SimpleTableRenderer" owl="1">
        <div class="o_simple_table_view">
            <div class="table-responsive">
                <table class="table table-sm table-hover o_simple_table">
                    <thead>
                        <tr>
                            <th class="o_simple_table_header">ID</th>
                            <th class="o_simple_table_header">Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr t-foreach="records" t-as="record" 
                            t-key="record.id"
                            class="o_simple_table_row"
                            t-on-click="() => this.onRowClick(record)"
                            style="cursor: pointer;">
                            <td class="o_simple_table_cell">
                                <t t-esc="record.id"/>
                            </td>
                            <td class="o_simple_table_cell">
                                <t t-esc="record.name"/>
                            </td>
                        </tr>
                        <tr t-if="!records.length">
                            <td colspan="2" class="text-center text-muted">
                                No records found
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </t>

    <t t-name="simple_table_view.SimpleTableButtons" owl="1">
        <!-- Boutons supplémentaires si nécessaire -->
    </t>

</templates>
EOF

# Afficher les permissions et finaliser
chmod +x "$MODULE_PATH"/../create_simple_table_module.sh 2>/dev/null || true

echo "✅ Module Simple Table View créé avec succès dans: $MODULE_PATH"
echo ""
echo "Structure créée:"
echo "📁 $MODULE_PATH/"
echo "├── 📄 __init__.py"
echo "├── 📄 __manifest__.py"
echo "├── 📁 models/"
echo "│   ├── 📄 __init__.py"
echo "│   └── 📄 ir_ui_view.py"
echo "├── 📁 static/"
echo "│   └── 📁 src/"
echo "│       ├── 📁 js/"
echo "│       │   ├── 📄 simple_table_controller.js"
echo "│       │   ├── 📄 simple_table_model.js"
echo "│       │   ├── 📄 simple_table_renderer.js"
echo "│       │   └── 📄 simple_table_view.js"
echo "│       └── 📁 xml/"
echo "│           └── 📄 simple_table_view.xml"
echo "├── 📁 views/"
echo "│   └── 📄 partner_views.xml"
echo "└── 📁 security/"
echo "    └── 📄 ir.model.access.csv"
echo ""
echo "🚀 Pour installer le module:"
echo "1. Copiez le dossier dans votre répertoire addons Odoo"
echo "2. Redémarrez Odoo avec --update=all ou installez via l'interface"
echo "3. Le menu 'Partners Simple Table' apparaîtra sous Contacts"
