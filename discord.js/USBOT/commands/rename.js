//RENAME

const Discord = module.require('discord.js');

module.exports.run = async (bot, message, args) => {

//console.log(args[0]);// user
//console.log(args[1]);// role
//console.log(args[2]);//time

if(message.member.hasPermission("ADMINISTRATOR")) {

  if(!args){
    return message.channel.send(":x: " + "| Merci d\'entrer un nouveau nom pour le bot");
  }
  message.guild.member(bot.user).setNickname(args.join(" ")).then(user => message.channel.send("Mon nouveau nom est " + args.join(" ") + "!")).catch(console.error);
} else {
  return message.reply(":x: " + "| Erreur, vous devez être  \"Administrateur\" pour faire cela")
  }
}

module.exports.help = {
    name: "rename"
}