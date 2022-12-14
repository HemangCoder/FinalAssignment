import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import createUser from '@salesforce/apex/CommunityAndContact.createUser';


export default class CommunityUserForContact extends LightningElement {
    @api recordId;

    handleCancel(event){
        console.log("Cancel");
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleSuccess(event) {
        console.log('called');
        console.log(this.recordId);
        //pass the contact record id to apex class and create user for it
        createUser({recordId : this.recordId})
        .then(result=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message:  'User created successfully.',
                    variant: 'success',
                })
            );
            this.dispatchEvent(new CloseActionScreenEvent());
        })
        .catch(error=>{
            var err = JSON.stringify(error);
            const obj = JSON.parse(err);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Failure',
                    message: obj.body.message,
                    variant: 'error',
                })
            );
        })
        
    }
}