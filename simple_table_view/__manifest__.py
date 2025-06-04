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
        # 'security/ir.model.access.csv',
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
    "license": "LGPL-3",
}
