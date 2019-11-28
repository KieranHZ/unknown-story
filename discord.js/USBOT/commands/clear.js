//CLEAR
  

  module.exports.run = async (bot, message, args) => {

    if(message.member.hasPermission("MANAGE_MESSAGES")) {
      let messagecount = parseInt(args[0]);
    
      if(isNaN(messagecount)) return message.channel.send(":x: " + "| Merci de mentionner le nombre de messages à effacer!");
    
      if(messagecount > 100){
        message.channel.send(":x: " + "| Erreur, merci d\'entrer un nommbre de messages compris entre 2 et 100 à la fois !")
      }else if(messagecount < 2 ) {
        message.channel.send(":x: " + "| Erreur, merci d\'entrer un nommbre de messages compris entre 2 et 100 à la fois !")
      } else {
    
      }{
        message.channel.fetchMessages({limit: messagecount}).then(messages => message.channel.bulkDelete(messages, true));
      }
    } else {
      return message.reply(":x: " + "| Vous devez être du \"STAFF\" pour effectuer une purge")
    }
    }
    
    module.exports.help = {
        name: "clear"
    }