
console.log('PlanningChantierModel');



export class PlanningChantierModel {
    constructor(env) {
        this.env = env;
        this.orm = env.services.orm;

        // Données locales
        this.partners = [];
        this.searchValue = "";
    }

    async loadData(searchQuery = "") {
        const domain = searchQuery ? [["name", "ilike", searchQuery]] : [];
        const partners = await this.orm.searchRead("res.partner", domain, ["id", "name"]);
        this.partners = partners;
        this.searchValue = searchQuery;
    }
}
