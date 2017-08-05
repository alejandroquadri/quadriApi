console.log(`Hola Maurito querido
	me parece perfecto que 
	te divierta programar`);

const pepe = 'juanjo';
let lupe = 'bebita';

export class TapeMachine{
    constructor(){
        this.recordedMessage = '';
    }
    record(message){
        this.recordedMessage = message;
    }
    play(){
        console.log(this.recordedMessage);
    }
}
