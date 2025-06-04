{
    'name': 'Vue Minimaliste',
    #'version': '17.0.1.0.0',
    'category': 'Tools',
    'summary': 'Ajoute un nouveau type de vue minimaliste',
    'description': '''
        Ce module ajoute un nouveau type de vue "vue_minimaliste" 
        qui affiche un tableau simple avec les champs id et name.
    ''',
    'author': 'Votre Nom',
    'depends': ['base', 'web'],
    'data': [
        'views/res_partner_views.xml',
    ],
    'assets': {
        'web.assets_backend': [
            'vue_minimaliste/static/src/js/vue_minimaliste.js',
            'vue_minimaliste/static/src/xml/vue_minimaliste.xml',
            'vue_minimaliste/static/src/css/vue_minimaliste.css',
        ],
    },
    'installable': True,
    'application': False,
    'auto_install': False,
    "license": "LGPL-3",

}
