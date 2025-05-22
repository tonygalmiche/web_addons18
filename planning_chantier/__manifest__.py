{
    "name": "Vue Planning Chantier",
    "version": "1.0",
    "category": "InfoSaône",
    "summary": "Vue Owl personnalisée pour planning chantier",
    "description": """
        Ce module ajoute une vue personnalisée Owl intitulée 'Planning Chantier',
        permettant d'afficher une liste de partenaires avec leurs ID et noms,
        intégrée dans le modèle res.partner.
    """,
    "depends": ["web"],
    "data": [
        "views/planning_views.xml"
    ],
    "assets": {
        "web.assets_backend": [
            # "planning_chantier/static/src/views/planning_chantier_template.xml",
            "planning_chantier/static/src/views/planning_chantier_model.js",
            "planning_chantier/static/src/views/planning_chantier_renderer.js",
            "planning_chantier/static/src/views/planning_chantier_controller.js",
            "planning_chantier/static/src/views/planning_chantier_view.js",
            # "planning_chantier/static/src/views/planning_chantier_registry.js"
        ]
    },
    "installable": True,
    "application": True,
    "auto_install": True,
    "license": "LGPL-3",
    "icon": "/planning_chantier/static/description/icon.png"
}
