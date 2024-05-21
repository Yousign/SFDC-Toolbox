import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class DisplayRecordInfo extends NavigationMixin(LightningElement)
{
    @api
    recordId;
    @api
    fields;
    @api
    width;
    @api
    align;
    @api
    objectType;
    @api
    icon;
    @api
    title;
    @api
    addLink;
    @api
    linkTarget;

    showData = false;
    showTitle;
    showIcon;
    fieldsArray;
    errorMessage;
    linkUrl;
    pageRef;
    

    connectedCallback()
    {        
        // make fields an array
        this.fieldsArray = this.fields.split(',');
        this.showData = true;

        this.showTitle = this.icon !== undefined || this.title !== undefined;
        
        if (this.addLink)
        {
            this.pageRef = {
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view',
                },
            };
            // Generate a URL to a User record page
            this[NavigationMixin.GenerateUrl](this.pageRef).then((url) => {
                this.linkUrl = url;
            });
        }
    }

    renderedCallback()
    {
        // set component width
        let css = this.refs.container.style;
        css.setProperty('--boxwidth', this.width);

        switch (this.align) {
            case "center":
                css.setProperty('--alignLeft', "auto");
                css.setProperty('--alignRight', "auto");
                break;
            case "right":
                css.setProperty('--alignLeft', "auto");
                css.setProperty('--alignRight', "0");
                break;
            default:
                css.setProperty('--alignLeft', "0");
                css.setProperty('--alignRight', "auto");
                break;
        }
    }

    handleNavigation(evt)
    {
        // Stop the event's default behavior.
        // Stop the event from bubbling up in the DOM.
        evt.preventDefault();
        evt.stopPropagation();
        // Navigate to the Account Home page.
        this[NavigationMixin.Navigate](this.pageRef);
    }
}