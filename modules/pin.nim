import telegrambot, db, utils

let pinCollection = getCollection("pins")

proc registerPinCommands(bot: Bot) =
  bot.command("pinned", "Get the current pinned message.") do (ctx: Context) =
    let pinned = pinCollection.findOne()
    if pinned.isNone:
      await ctx.reply("No pinned message.")
    else:
      await ctx.reply(pinned["text"].getStr())
      
  bot.command("pin", "Pin a message.") do (ctx: Context) =
    if ctx.message.replyTo.isNone:
      await ctx.reply("Reply to a message to pin it.")
    else:
      let messageId = ctx.message.replyTo.messageId
      pinCollection.update({}, {"messageId": messageId}, upsert = true)
      await ctx.pinChatMessage(messageId)
      await ctx.reply("Message pinned!")

  bot.command("unpin", "Unpin the current message.") do (ctx: Context) =
    pinCollection.delete({})
    await ctx.unpinChatMessage()
    await ctx.reply("Message unpinned!")
