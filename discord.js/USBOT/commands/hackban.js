//HACKBAN

module.exports.run = (bot, message, args, discord) => {
  let mid = args.join(' ');
  if (!message.member.hasPermission(["BAN_MEMBERS"], false, true, true)) return message.channel.send("Vous ne disposez pas de permissions suffisantes");
    bot.fetchUser(mid).then(id => {
      message.guild.ban(id).catch(err => {
        message.channel.send("Erreur :x: " + "| Il est impossible de bannir "+id)
        console.log(err)
      })
      message.channel.send(`https://giphy.com/gifs/ban-banned-admin-fe4dDMD2cAU5RfEaCU, L\'ID ${id} viens d\'être bannis`)
    }).catch(() => {
      message.channel.send(`Erreur :x: | Aucun utilisateur n\'est rattaché à l\'ID ${mid}, merci de réessayer`)
    })
}

module.exports.help = {
  name: "hackban"
}