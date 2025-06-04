from odoo import models, fields, api



class IrUiView(models.Model):
    _inherit = 'ir.ui.view'
    
    type = fields.Selection(selection_add=[('simple_table', 'Simple Table')], ondelete={'simple_table': 'cascade'})

    @api.model
    def _get_view_info(self):
        """Override to add simple_table view information"""
        view_info = super()._get_view_info()
        view_info['simple_table'] = {
            'icon': 'oi oi-view-list',
            'name': 'Simple Table',
            'multi_record': True,
        }
        return view_info


class ActWindowView(models.Model):
   _inherit = 'ir.actions.act_window.view'
   
   view_mode = fields.Selection(selection_add=[('simple_table', 'Simple Table')], ondelete={'simple_table': 'cascade'})


class ActWindow(models.Model):
   _inherit = 'ir.actions.act_window'
   
   def _get_view_mode_list(self):
       """Add simple_table to available view modes"""
       view_modes = super()._get_view_mode_list()
       if 'simple_table' not in view_modes:
           view_modes.append('simple_table')
       return view_modes






