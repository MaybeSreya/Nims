import telegrambot, utils

proc registerBanCommands(bot: Bot) =
  bot.command("ban", "Ban a user.") do (ctx: Context) =
    if ctx.message.replyTo.isNone:
      await ctx.reply("Reply to a user to ban them.")
    else:
      let userId = ctx.message.replyTo.from.id
      await ctx.kickChatMember(userId)
      await ctx.reply("User banned!")

  bot.command("mute", "Mute a user.") do (ctx: Context) =
    if ctx.message.replyTo.isNone:
      await ctx.reply("Reply to a user to mute them.")
    else:
      let userId = ctx.message.replyTo.from.id
      await ctx.restrictChatMember(userId, canSendMessages = false)
      await ctx.reply("User muted!")
