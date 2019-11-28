//Created by Shedhatch

//Dependencies
const Discord = require('discord.js');
const client = new Discord.Client();

//Config
const botconfig = require('./botconfig.json');
const prefix = (botconfig.prefix); 
client.login (botconfig.token);

//Activity
client.on ("ready",fonction => {
    console.log('Pret');
    client.user.setStatus("idle");
    client.user.setActivity("Mp moi");
        return (console.error);
    });

//Support dm // channel
client.on('message', function(message){
    if (message.channel.type == 'dm'){
        client.channels.get("Channel.id").send({embed: { 
                color: 0xffff00,
                author: {
                  name: message.author.username,
                  icon_url: message.author.avatarURL
                },
                title: `ID | ${message.author.id}`,
                url: "",
                description: "",
                fields: [{
                    name: `Contenu du message`,
                    value: `${message.content}`
                  }, 
                ],
              timestamp: new Date(),
                footer: {
                  text: "Support Bot"
                }
              }
            });
            }
            });
            
//Avoid timeout websocket
client.on('error', console.error);


