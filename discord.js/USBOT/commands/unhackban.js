//UNHACKBAN

module.exports.run = (bot, message, args, discord) => {
  let id = args.join(' ');
  if (!message.member.hasPermission(["BAN_MEMBERS"], false, true, true)) return message.channel.send(`Vous ne disposez pas de permissions suffisantes`);
  let member = bot.fetchUser(id)
  .then(user => {
    message.guild.unban(user.id)
    .then(() => {
      message.channel.send(`L\'utilisateur à bien été débannis ${user}.`)
    }).catch(err => {
        message.channel.send(`Erreur :x: | ${user} n\'a pas pu être débannis`)
    })
  }).catch(() => message.channel.send("Erreur :x: | Aucun utilisateur n\'est rattaché à l\'ID mentionné"))
}
  

module.exports.help = {
  name: "unhackban"
}