import telegrambot

proc registerAdminCommands(bot: Bot) =
  bot.command("promote", "Promote a user.") do (ctx: Context) =
    if ctx.message.replyTo.isNone:
      await ctx.reply("Reply to a user to promote them.")
    else:
      await ctx.promoteChatMember(ctx.message.replyTo.from.id, canManageChat=true)
      await ctx.reply("User promoted!")

  bot.command("demote", "Demote a user.") do (ctx: Context) =
    if ctx.message.replyTo.isNone:
      await ctx.reply("Reply to a user to demote them.")
    else:
      await ctx.demoteChatMember(ctx.message.replyTo.from.id)
      await ctx.reply("User demoted!")

  bot.command("adminlist", "List current admins.") do (ctx: Context) =
    let admins = await ctx.getChatAdministrators()
    await ctx.reply("Admins: " & admins.mapIt(it.user.username).join(", "))
