//TIMER

const Discord = module.require('discord.js');
const ms = require('ms');

module.exports.run = async (bot, message, args) => {

  let Timer = args[0];

  if(!args[0]){
    return message.channel.send(":x:" + "| Erreur, Merci d\'entrer le temps néscessaire en \"s ou m ou h\"");
  }

  if(args[0] <= 0){
    return message.channel.send(":x:" + "| Erreur, Merci d\'entrer le temps néscessaire en \"s ou m ou h\"");
  }

  message.channel.send("⏱️ " + "| Le chronomètre démarre : " + `${ms(ms(Timer), {long: true})}`)

  setTimeout(function(){
    message.channel.send(message.author.toString() + ` Les ${ms(ms(Timer), {long: true})} sont écoulées`)

  }, ms(Timer));
}

module.exports.help = {
    name: "timer"
}