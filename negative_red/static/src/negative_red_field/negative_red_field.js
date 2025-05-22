import { registry } from "@web/core/registry";
import { FloatField, floatField } from "@web/views/fields/float/float_field";
import { _t } from "@web/core/l10n/translation";


// TODO : Exemple d'utilisation du widget
//    <field name="is_effectif" optional="show" widget="negative_red" options="{                 
//         'format_class': [['&lt;0', 'negative_red'],['&gt;0', 'positive_green']]}"/>
//     <field name="currency_id" optional="show"/>


export class NegativeRedField extends FloatField {
    //static template = "negative_red.NegativeRedTemplate";

    static props = {
        ...FloatField.props,
        format_class: { type: Array, optional: true },
    };
    static defaultProps = {
        ...FloatField.defaultProps,
        format_class:[],
    };


    setClass(class_css){
        let bdom = this.__owl__.bdom;
        if(bdom){
            let parent = bdom.parentEl.parentElement; // td
            if (parent){
                parent.className =  parent.className + ' ' + class_css;
            }
        }
    }


    get formattedValue() {
        let myValue = super.formattedValue;
        //console.log('TEST',this.props, this.props.name, this.props.record.activeFields);
        let format_class = this.props.format_class;
        if (format_class.length>0) {
            for (let i = 0; i < format_class.length; i++) {
                let val = this.value + ' ' + format_class[i][0];
                let class_css = format_class[i][1];
                //Vérfier que la chaine ne contient que <, >, = et des chiffres
                let pattern = /^\s*-?\d+\s*(?:[<>=]|<=|>=|===?|!==?)\s*-?\d+\s*$/;
                let match = val.match(pattern);
                if (!match) {
                    console.log("Format invalide", val);
                } else {
                    if (eval(val)){
                        this.setClass(class_css);
                        break;
                    }
                }
            }
        } else {
            if (this.value<0){
                this.setClass('negative_red');
            }
        }  
        if (this.value==0){
            myValue='';
        }     
        return myValue
    }
}


export const negativeRedField = {
    ...floatField,
    component: NegativeRedField,
    // supportedOptions: [
    //     ...floatField.supportedOptions,
    //     {
    //         label: _t("Factor"),
    //         name: "factor",
    //         type: "number",
    //     },
    // ],
    extractProps({ options }) {
        const props = floatField.extractProps(...arguments);
        props.format_class = options.format_class;
        return props;
    },
};


registry.category("fields").add("negative_red", negativeRedField);



