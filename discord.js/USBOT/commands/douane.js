const Discord = require("discord.js");
const fs = require("fs");

module.exports.run = async (bot, message, args) => {


    let question = [
      "Si je pars faire de l'illégal dans mon **véhicule d'entreprise**, qu'es ce que je n'ai pas le droit de faire une fois arrivé a destination ?", 
      "Donner la définition du terme Powergaming.",
      "Quand tu utilises **le chat [T]** pour twitter une information, est-il important de mettre ton nom et prénom devant le message envoyé ?",
      "Quels sont les types de pseudos interdits sur le discord pour les personnes whitelistées ?", 
      "Quelle est la **réglementation** afin de pouvoir streamer sur le serveur ?", 
      "Comment transmettre un dossier de mort RP au staff ?", 
      "Citer 3 zones dites 'zones contrôlées.", 
      "Comment postuler à une entreprise ?", 
      "Le rp lspd ripoux est-il autorisé ?", 
      "Un agent de la Lspd, peut-il procéder à une fouille ?", 
      "Lister les règles du coma.", 
      "Si monsieur X te mets dans le coma, as tu le droit de revenir sur les lieux de l'action pour te venger ?", 
      "Peut-on forcer une personne à vider son compte en banque ?", 
      "Quelle est la différence entre une mort RP et un coma ?", 
      "Combien de personnes peuvent appartenir à un groupe illégal ?", 
      "Comment appelle t'on une touche ingame ?", 
      "La publicité est elle autorisée sur d'autres serveurs discord ?", 
      "As-tu le droit de te balader en voiture de police si tu n'es pas membre des services de police ?", 
      "Comment masquer son identité ?", 
      "Faut-il changer son pseudo steam avec son nom/prénom rp avant de se connecter ?", 
  ];

    let cible = Math.floor((Math.random() * question.length));

    

     message.channel.send(`${question[cible]}`);
       
    }
  


  module.exports.help = {
    name: "question"
  }