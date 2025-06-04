/** @odoo-module **/

import { Model } from "@web/model/model";


console.log('SimpleTableModel');


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
