//PUNISH

const Discord = require("discord.js");
const ms = require("ms");

module.exports.run = async (bot, message, args) => {



  let tomute = message.guild.member(message.mentions.users.first() || message.guild.members.get(args[0]));
  if(!tomute) return message.channel.send(":x:" + "| Erreur Merci de mentionner un utilisateur");
  if(!message.member.hasPermission("MANAGE_MESSAGES")) return message.channel.send(":x:" + "| Erreur vous ne disposez pas des permissions néscessaires");
  if(tomute.hasPermission("MANAGE_MESSAGES")) return message.channel.send(":x:" + "| Erreur il est impossible de punir cet utilisateur");
  if (tomute.id === message.author.id) return message.channel.send(":x:" + "| Erreur il est impossible de vous auto-bâillonné");
  let muterole = message.guild.roles.find(`name`, "Bâillon discord");

  if(!muterole){
    try{
      muterole = await message.guild.createRole({
        name: "Bâillon discord",
        color: "#000000",
        permissions:[]
      })
      message.guild.channels.forEach(async (channel, id) => {
        await channel.overwritePermissions(muterole, {
          SEND_MESSAGES: false,
          ADD_REACTIONS: false
        });
      });
    }catch(e){
      console.log(e.stack);
    }
  }

  let mutetime = args[1];
  if(!mutetime) return message.channel.send(":x:" + "| Erreur merci d\'indiquer une période en s/m/h/d/w.");

  await(tomute.addRole(muterole.id));
  message.channel.send('Application du rôle ``bâillon discord``' + ` à <@${tomute.id}>, je le retirerai dans ${ms(ms(mutetime))}.`);

  setTimeout(function(){
    tomute.removeRole(muterole.id);
    message.channel.send('Je viens de retirer le rôle ``bâillon discord``' + ` à <@${tomute.id}>, il est désormais libre d\'écrire.`);
  }, ms(mutetime));

 // message.delete();

}

module.exports.help = {
  name: "punish"
}