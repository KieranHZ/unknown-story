//created by Shedhatch version 2.1 

//Dependencies
const Discord = require('discord.js');
const bot = new Discord.Client();
const fs = require ('fs')
const ms = require('ms');

//Config
const botconfig = require('./botconfig.json');
const prefix = (botconfig.prefix);
const version = (botconfig.version);
bot.login (botconfig.token);


//Activity
bot.on ("ready",fonction => {
console.log(`USBOT ~~ Ready // Version: ${version} // Prefix ${prefix}`);
bot.user.setStatus("online");
bot.user.setActivity(`${prefix}info ~~ Unknown Story`);
return (console.error);
});

//Command file
bot.commands = new Discord.Collection();

fs.readdir("./commands/", (err, Files) =>{
if(err) console.log(err);
  
let jsfile = Files.filter(f => f.split(".").pop() ==="js")
if(jsfile.length <= 0){
console.log("commande introuvable");
return;
}
  
jsfile.forEach((f, i ) => {
let props = require(`./commands/${f}`);
console.log(`${f} loaded!`); 
bot.commands.set(props.help.name, props);
})
})

bot.on("message", async message => {
if(message.author.bot) return;
if(message.channel.type === "dm")return;
    
let messageArray = message.content.split(" "); 
let cmd = messageArray[0];
let args = messageArray.slice(1);

let commandfile = bot.commands.get(cmd.slice(prefix.length));
if(commandfile) commandfile.run(bot,message, args);

});

//Avoid timeout websocket
bot.on('error', console.error);

//Code
//Saids
bot.on("message", message => {
if(message.content.startsWith(prefix + "dit")) {
  if(message.member.hasPermission("ADMINISTRATOR")) {
message.delete().catch();
var text = message.content.split(' ').slice(1).join(' ');
if(!text) return message.reply(`Cet argument est incorrect -> Ex: ${prefix}dit salut`);
message.channel.send(text);
}}
});


//Top serveurs [CM]
bot.on("message", message => {
  if(message.content === prefix + "pub"){
  message.channel.send("Citoyens, n'hésitez pas à aller voter :inbox_tray: et mettre un petit commentaire étoilé :star: pour le serveur Unknown Story RP qui est mis à l’affiche sur le site TOP SERVEURS: https://gta.top-serveurs.net/fr-unknown-story-rp :beginner: ceci est très important pour l’agrandissement du serveur, vous pouvez voter toutes les 2 heures :beginner: :computer: à la fois sur votre ordinateur aussi sur votre smartphone :calling:");
      
  }
 });
									

//Help [CM]
bot.on("message", message => {
  if(message.content === prefix + "info"){
   // message.delete().catch();
 message.channel.send({embed: {
  color: 0x11c191,
  author: {
  },
  title: "AIDE AUX COMMANDES",
  url: "",
  description: `Le préfixe du bot est '${prefix}'`,
  fields: [
    {
      name: `${prefix}ip`,
      value: "Donne l\'ip du serveur ingame (personnes WL uniquement)"
    },
    {
      name: `${prefix}pub`,
      value: "Donne le lien de la page Top serveurs"
    },
    {
      name: `${prefix}web`,
      value: "Donne le lien du site web"
    },
    {
      name: `${prefix}faq`,
      value: "Vous affiche la page wiki du serveur"
    },
    {
      name: `${prefix}meta; /hrp; /rp`,
      value: "Le bot donne les définitions"
    },
    {
      name: `${prefix}cache + @user`,
      value: "Cible un tuto pour vider son cache"
    },
    {
      name: `${prefix}radio`,
      value: "Cible un tuto pour personaliser sa playlist IG"
    },
    {
      name: `${prefix}info`,
      value: "Vous affiche ce menu"
    },
  
    
    
  ],
  timestamp: new Date(),
  footer: {
    text: "Propulsé par Unknown Story"
  }
}
});
}
});	

//Help admin [CM]
bot.on("message", message => {
  if(message.content === prefix + "admin"){
    if(message.member.hasPermission("ADMINISTRATOR")) {
    message.delete().catch();
 message.channel.send({embed: {
  color: 0x2d9386,
  author: {
  },
  title: "AIDE AUX COMMANDES ADMINISTRATEUR",
  url: "",
  description: `Le préfixe du bot est '${prefix}'`,
  fields: [{
      name: `${prefix}hackban + ID`,
      value: "Permets de bannir un utilisateur hors discord avec son ID"
    },
    {
      name: `${prefix}unhackban + ID`,
      value: "Permets de débannir un utilisateur hors discord avec son ID"
    },
    {
      name: `${prefix}dit`,
      value: "Faire parler le bot"
    },
      
    
    
  ],
  timestamp: new Date(),
  footer: {
    text: "Propulsé par Unknown Story"
  }
}
});
}
  }})

//Help staff [CM]
bot.on("message", message => {
    if(message.content === prefix + "staff"){
      if(message.member.hasPermission("MANAGE_MESSAGES")) {
      message.delete().catch();
   message.channel.send({embed: {
    color: 0x2d9386,
    author: {
    },
    title: "AIDE AUX COMMANDES STAFF",
    url: "",
    description: `Le préfixe du bot est '${prefix}'`,
    fields: [{
        name: `${prefix}roles`,
        value: "Affiche les différents rôles de ce serveur"
      },
      {
        name: `${prefix}clear + nb de messages`,
        value: "Permets d\'effacer des messages en masse"
      },
      {
        name: `${prefix}help + @user`,
        value: "Permets d\'expliquer à un joueur comment être WL"
      },
      {
        name: `${prefix}id + @user`,
        value: "Permets de connaitre l'id d'un utilisateur"
      },
      {
        name: `${prefix}punish + @user + période en s/m/h/d/w`,
        value: "Permets de bâillonner un utilisateur (mute)"
      },
      {
        name: `${prefix}modlock + période en s/m/h/d/w`,
        value: "Permets de vérouiller un channel textuel"
      },
      {
        name: `${prefix}modlock + unlock`,
        value: "Permets de dévérouiller un channel textuel avant le temps indiqué"
      },
      {
        name: `${prefix}strike + @user + raison`,
        value: "Ajouter un avertissement à un utilisateur"
      },
      {
        name: `${prefix}strikelevel + @user`,
        value: "Connaître le nombre d\'avertissements que détiens un utilisateur"
      },
 	{
        name: `${prefix}douane`,
        value: "Vous propose une question random sur le réglement"
      },
 	{
        name: `${prefix}report + rapport de douane`,
        value: "Soumettre un rapport de douane dans le channel <#578851864981012491>"
      },

    
     
     
    ],
    timestamp: new Date(),
    footer: {
      text: "Propulsé par Unknown Story"
    }
  }
  });
  }
    }})
  
//Anti advert
bot.on('message', (message) => { 
  if (message.content.includes('discord.gg/'||'discordapp.com/invite/')) { 
    message.delete()
      .then(message.channel.send(`Lien d\'invitation supprimé pour les utilisateurs.\n**ATTENTION** <@&576322630316195850>, ${message.author} avec son id ${message.author.id}\nà tenté de poster un lien d\'invitation vers un autre serveur discord`))
  }
})

//Question
bot.on('message', message => {
  if (message.content.startsWith(prefix + 'help')) {
    const user = message.mentions.users.first();
    if (user) {
      const member = message.guild.member(user);
      if (member) {
        message.channel.sendMessage((user) + ' je t\'invite si cela n\'est pas déjà fait à lire les channels textuels suivants: <#576361080012537867> ou <#576364936863940608>, ils devraient t\'apporter de plus amples informations.');
        message.delete([1000]);
        console.log('Help pour ' + user.username);
      }
    }
  }

 
})

//Definitions RP
//Meta
bot.on("message", message => {
if(message.content === prefix+ "meta"){
//message.delete().catch();
message.channel.send({embed: {
color: 0x808080,
author: {
},
title: "",
url: "",
description: "",
fields: [{
name: "METAGAMING",
value: "Définition METAGAMING: Metagame (ou métagame, parfois traduit en « méta-jeu ») désigne, dans le cadre d'un jeu, l'ensemble des stratégies et des méthodes qui ne sont pas explicitement prescrites par quelque règle que ce soit, mais qui résultent de la seule expérience des joueurs. — Wikipédia    \n\n Exemples concrets de METAGAMING sur le chat Discord:   \n Où es-tu?  \n Qui est le responsable de cette entreprise?  \n Qui est en ville?  \n Exemple de METAGAMING concret:  \n Utiliser les informations sur ce Discord (ou un autre site, Stream, Live etc.) pour vous en servir IG (In Game).  \n Conseil: Vous devez faire sur GTAV RP comme dans la vie réelle, utilisez votre téléphone, rencontrer du monde, créer son propre réseau.... Seuls les informations sur les channels Discord RP (exemple entreprise, évènements, etc) peuvent être utilisés IG (IN Game)."
},
],
timestamp: new Date(),
footer: {
text: "© Unknown Story RP"
}
}
});
}
});

//Hrp
bot.on("message", message => {
  if(message.content === prefix + "hrp"){
  //  message.delete().catch();
 message.channel.send({embed: {
  color: 0x808080,
  author: {
  },
  title: "",
  url: "",
  description: "",
  fields: [{
      name: "HORS ROLE PLAY",
      value: "Dans les jeux vidéo, le terme de 'HRP' est l'acronyme franglais de Hors RolePlay qui désigne toute discussion venant du joueur et non du personnage. — Wikipédia. \n\nExemple: \n-Ce sont donc les joueurs qui s'expriment et non plus les personnages."
    },
    
  ],
  timestamp: new Date(),
  footer: {
    text: "© Unknown Story RP"
  }
}
});
}
});

//Rp
bot.on("message", message => {
  if(message.content === prefix + "rp"){
  //  message.delete().catch(); 
 message.channel.send({embed: {
  color: 0x808080,
  author: {
  },
  title: "",
  url: "",
  description: "",
  fields: [{
      name: "ROLE PLAY",
      value: "Le rôle play c'est le fait d'incarner un personnage et de faire sa vie en jeu. Vous faîtes exactement comme si vous meniez une vie , vous avez un job, une maison, des véhicules, vous pouvez être marier ou être emprisonné."
    },

  ],
  timestamp: new Date(),
  footer: {
    text: "© Unknown Story RP"
  }
}
});
}
});


//Ip
bot.on("message", message => {
  if(message.content === prefix + "ip"){
    if(message.member.hasPermission("ADD_REACTIONS")) {
  message.channel.send("Pour vous connecter au serveur utilisez l\'onglet 'Direct connect' \n```unknownstory.fr:30120```");
      
  }
 }});

  //Faq
 bot.on("message", message => {
    if(message.content === prefix + "faq"){
    message.channel.send({embed: {
    color: 0x11c191,
    author: {
      name: message.author.username,
      icon_url: message.author.avatarURL
    },
    title: "Accès à la FAQ",
    url: "http://unknownstory.fr/index.php/foire-aux-questions/",
    description: "**Discord, Entretien, Serveur...**",
   
  
    }
    });
    }
    });	


 //Web
 bot.on("message", message => {
    if(message.content === prefix + "web"){
    message.channel.send({embed: {
    color: 0x11c191,
    author: {
      name: message.author.username,
      icon_url: message.author.avatarURL
    },
    title: "Accès au site internet",
    url: "http://unknownstory.fr/",
    description: "**Règlement, Staff, Patchnotes...**",
   
  
    }
    });
    }
    });	
    

//Tuto
//Cache
bot.on('message', message => {
  if (message.content.startsWith(prefix + 'cache')) {
    const user = message.mentions.users.first();
    if (user) {
      const member = message.guild.member(user);
      if (member) {
        message.channel.sendMessage((user) + ' Voici les étapes pour vider son cache: \n```1) Localiser votre application Fivem. \n2) Faire un clic droit sur l\'application puis sélectionner "Ouvrir l\'emplacement du fichier". \n3) Ouvrir le dossier "🐌 FiveM Application Data". \n4) Sélectionner le dossier "cache" puis l\'ouvir. \n5) Supprimer tous les fichiers sauf le dossier "game" comme indiqué ci-dessous.```');
        message.channel.sendMessage("https://cdn.discordapp.com/attachments/517643751976599553/591286865160699923/cache.JPG")
      
      }
    }
  }


})

//Radio Fivem
bot.on('message', message => {
  if (message.content.startsWith(prefix + 'radio')) {
    const user = message.mentions.users.first();
    if (user) {
      const member = message.guild.member(user);
      if (member) {
        message.channel.sendMessage((user) + ', **Comment personnaliser votre radio IG ?**\n Incluse dans les nouvelles fonctionnalités de Grand Theft Auto V sur PC, la Radio Perso vous permet de parcourir Los Santos avec en fond sonore votre propre station de radio personnalisée. Il suffit d\'apporter quelques modifications aux paramètres audio en jeu pour pouvoir ajouter des fichiers audio externes.');
        message.channel.sendMessage("[https://www.rockstargames.com/fr/newswire/article/52419/self-radio-create-your-own-custom-radio-station-in-gtav-pc]")
      }
    }
  }

 
})

//Douane commande
    bot.on('message', async message =>  {
      let messageArray = message.content.split(" ");
      let cmd = messageArray[0];
      let args = messageArray.slice(1);
       if(cmd === prefix + 'report'){
      let proposition = args.join(" ").slice();
       let cmdpropositionEmbed = new Discord.RichEmbed()
      .setTitle('RAPPORT DE DOUANE\n')
      .setColor("0xffffff")
      .addField("Heure du rapport", message.createdAt)
      .addField("Rédigé par", `${message.author} | ID: ${message.author.id}`)
      .addField("Contenu du rapport",proposition);
      
      let cmdpropositionChannel = message.guild.channels.find("name", "whitelist-report");
      if(!cmdpropositionChannel) return message.channel.send('je ne trouve pas le salon "whitelist-report"');
      cmdpropositionChannel.send(cmdpropositionEmbed).then(async( msg)=> {
        msg.react('✅').then(()=> {
          msg.react('❎')
        })
      })
      message.delete(1000);
      return(console.error);
        }
       })