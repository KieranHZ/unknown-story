//STRIKE

const Discord = require("discord.js");
const fs = require("fs");
const ms = require("ms");
let warns = JSON.parse(fs.readFileSync("./warnings.json", "utf8"));

module.exports.run = async (bot, message, args) => {


  if(!message.member.hasPermission("MANAGE_MESSAGES")) return message.channel.send(":x:" + "| Erreur, Vous ne détenez pas les permissions néscessaires");
  let wUser = message.guild.member(message.mentions.users.first()) || message.guild.members.get(args[0])
  if(!wUser) return message.channel.send(":x:" + "| Erreur, Merci de mentionner un utilisateur");
  if(wUser.hasPermission("MANAGE_MESSAGES")) return message.channel.send(":x:" + "| Erreur, Vous ne détenez pas les permissions néscessaires");
  let reason = args.join(" ").slice(22);

  if(!warns[wUser.id]) warns[wUser.id] = {
    warns: 0
  };

  warns[wUser.id].warns++;

  fs.writeFile("./warnings.json", JSON.stringify(warns), (err) => {
    if (err) console.log(err)
  });


  let warnchannel = message.channel.send(`<@${wUser.id}>, vous venez de recevoir un avertissement (Raison: \`${reason}\`).Total: ${warns[wUser.id].warns} avertissement(s) (${warns[wUser.id].warns} ces 30 derniers jours).`);

  if(warns[wUser.id].warns == 0){
    
    message.channel.send(`<@${wUser.id}> ne détiens pas d'avertissement(s).`); 
 }


         if(warns[wUser.id].warns == 2){
    
     message.channel.send("Limite atteinte, détiens plus de ``2 avertissements``.");  
  
            }


       /*  if(warns[wUser.id].warns == 300000){
           message.guild.member(wUser).ban(reason);
        message.reply(`<@${wUser.id}> has been banned.`)
         }*/

}

module.exports.help = {
  name: "strike"
}