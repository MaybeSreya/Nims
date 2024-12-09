import telegrambot, db

let greetingsCollection = getCollection("greetings")

proc registerGreetingCommands(bot: Bot) =
  bot.command("welcome", "Enable/disable welcome messages.") do (ctx: Context) =
    let state = ctx.args.toLowerAscii()
    case state
    of "yes", "on":
      greetingsCollection.update({"type": "welcome"}, {"enabled": true}, upsert = true)
      await ctx.reply("Welcome messages enabled.")
    of "no", "off":
      greetingsCollection.update({"type": "welcome"}, {"enabled": false}, upsert = true)
      await ctx.reply("Welcome messages disabled.")
    else:
      await ctx.reply("Usage: /welcome <yes/no/on/off>")

  bot.command("setwelcome", "Set the welcome message.") do (ctx: Context) =
    greetingsCollection.update({"type": "welcome"}, {"message": ctx.args}, upsert = true)
    await ctx.reply("Welcome message set!")

  bot.onJoin do (ctx: Context) =
    let welcome = greetingsCollection.findOne({"type": "welcome", "enabled": true})
    if welcome.isSome:
      let message = welcome["message"].getStr()
      await ctx.reply(message)
