import telegrambot, db, times

let afkCollection = getCollection("afk")

proc registerAFKCommands(bot: Bot) =
  bot.command("afk", "Set yourself as AFK with an optional message.") do (ctx: Context) =
    let reason = if ctx.args.len > 0: ctx.args else "I'm away from keyboard."
    let userId = ctx.message.from.id

    afkCollection.update(
      {"userId": userId},
      {"userId": userId, "reason": reason, "time": now()},
      upsert = true
    )

    await ctx.reply("You are now AFK: " & reason)

  bot.onMessage do (ctx: Context) =
    let userId = ctx.message.from.id
    let userAFK = afkCollection.findOne({"userId": userId})

    if userAFK.isSome:
      let reason = userAFK["reason"].getStr()
      let afkTime = parseTime(userAFK["time"].getStr())
      let duration = now() - afkTime

      await ctx.reply("Welcome back! You were AFK for " & duration.toNaturalStr() & ".\nReason: " & reason)

      afkCollection.delete({"userId": userId})

  bot.onMessage do (ctx: Context) =
    let mentionedUsers = ctx.message.entities?.filter(it.type == EntityType.Mention).mapIt(it.text.stripPrefix("@"))

    if mentionedUsers.len > 0:
      for username in mentionedUsers:
        let userAFK = afkCollection.findOne({"username": username})
        if userAFK.isSome:
          let reason = userAFK["reason"].getStr()
          let afkTime = parseTime(userAFK["time"].getStr())
          let duration = now() - afkTime

          await ctx.reply("@$username is currently AFK for " & duration.toNaturalStr() & ".\nReason: " & reason)
