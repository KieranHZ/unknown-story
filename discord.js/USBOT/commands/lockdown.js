//LOCKDOWN CHANNEL

const Discord = require('discord.js');
const bot = new Discord.Client();
const ms = require("ms");

exports.run = async (client, message, [time, reason]) => {
  if (!client.lockit) { client.lockit = []; }
  let validUnlocks = ["release", "unlock", "u"];
  if (!time) { return message.channel.send(":x:" + "| Erreur merci d\'indiquer une période en s/m/h/d/w"); }

  const Lockembed = new Discord.RichEmbed()
    .setColor(0xDD2E44)
    .setTimestamp()
    .setTitle("MOD LOCK [VÉROUILLÉ]")
    .setDescription(`Ce channel viens d\'etre vérouillé par ${message.author.tag} pendant ${time}`);
    if (reason != null) { Lockembed.addField("Raison : ", reason); }

  const Unlockembed = new Discord.RichEmbed()
    .setColor(0xDD2E44)
    .setTimestamp()
    .setTitle("MOD LOCK [DÉVÉROUILLÉ]")
    .setDescription("Ce channel est désormais dévérouillé");

  if (message.channel.permissionsFor(message.author.id).has("MANAGE_MESSAGES") === false) { 
    const embed = new new Discord.RichEmbed()
      .setColor(0xDD2E44)
      .setTimestamp()
      .setTitle("❌ ERREUR")
      .setDescription("Vous ne disposez pas des permissions néscessaires");
    return message.channel.send({embed});  
  }  

  if (validUnlocks.includes(time)) {
    message.channel.overwritePermissions(message.guild.id, { SEND_MESSAGES: null }).then(() => {
      message.channel.send({embed: Unlockembed});
      clearTimeout(client.lockit[message.channel.id]);
      delete client.lockit[message.channel.id];
    }).catch(error => { console.log(error); });
  } else {
    message.channel.overwritePermissions(message.guild.id, { SEND_MESSAGES: false }).then(() => {
      message.channel.send({embed: Lockembed}).then(() => {
        client.lockit[message.channel.id] = setTimeout(() => {
          message.channel.overwritePermissions(message.guild.id, {
            SEND_MESSAGES: null
          }).then(message.channel.send({embed: Unlockembed})).catch(console.error);
          delete client.lockit[message.channel.id];
        }, ms(time));
      }).catch(error => { console.log(error); });
    });
  }
};

exports.conf = {
  enabled: true,
  runIn: ["text"],
  aliases: ["ld", "lock"],
  permLevel: 2,
  botPerms: ["MANAGE_ROLES", "EMBED_LINKS", "ADMINISTRATOR"]
};
  
exports.help = {
  name: "modlock",
  description: "Locks or unlocks the channel.",
  usage: "[time:str] [reason:str]",
  usageDelim: " | "
};
