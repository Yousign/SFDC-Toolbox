import { LightningElement, api } from 'lwc';

export default class Util_showPDF extends LightningElement {
    @api fileId;
    @api heightInRem;
    @api maxNumberOfPages = 1;

    get pdfHeight() {
        return 'height: ' + this.heightInRem + 'rem';
    }

    get pageList()
    {
        let tab = [];
        let currentIndex = 0;
        if (this.maxNumberOfPages && (!isNaN(parseInt(this.maxNumberOfPages))))
        {
            let max = parseInt(this.maxNumberOfPages);
            while (currentIndex < max)
            {
                tab.push(currentIndex++);
            }
        }
        else
        {
            console.error(this.maxNumberOfPages + ' is not an Integer');
        }
        return tab;
    }
    
    urlByPage(evt) {
        if (!evt.target.dataset.loaded)
        {
            let pageNb = evt.target.dataset.pagenb;
            evt.target.dataset.loaded=true; // to avoid infinite loop
            evt.target.src = '/sfc/servlet.shepherd/version/renditionDownload?rendition=JPGZ&versionId=' + this.fileId + '&page=' + pageNb;
        }
    }

    // get first page
    get url() {
        return '/sfc/servlet.shepherd/version/renditionDownload?rendition=JPGZ&versionId=' + this.fileId;
    }
    
    onErrorImage(evt) {
        evt.target.classList.toggle("hide");
    }
}