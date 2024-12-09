import telegrambot, db

proc registerIDCommand(bot: Bot) =
  bot.command("id", "Fetch various IDs related to a message.") do (ctx: Context) =
    let message = ctx.message
    let chat = message.chat
    let user = message.from
    let reply = message.replyToMessage

    var text = "**Message ID:** `" & $message.messageId & "`\n"
    if user.isSome:
      text.add("**User:** [" & user.get.firstName & "](tg://user?id=" & $user.get.id & ") - `" & $user.get.id & "`\n")
    if chat.username.isSome:
      text.add("**Chat:** [" & chat.title & "](https://t.me/" & chat.username.get & ") - `" & $chat.id & "`\n")
    else:
      text.add("**Chat:** `" & $chat.id & "`\n")

    if ctx.args.len > 0:
      let target = ctx.args[0]
      try:
        let fetchedChat = await bot.getChat(target)
        if fetchedChat.isChannel:
          text.add("**Channel/Chat:** [" & fetchedChat.title & "](https://t.me/" & fetchedChat.username.getOrDefault("")) - `" & $fetchedChat.id & "`\n")
        else:
          text.add("**User:** [" & fetchedChat.firstName & "](tg://user?id=" & $fetchedChat.id & ") - `" & $fetchedChat.id & "`\n")
      except:
        await ctx.reply("⚠️ Unable to find user or chat: " & target)

    if reply.isSome:
      text.add("**Replied Message ID:** `" & $reply.get.messageId & "`\n")
      if reply.get.from.isSome:
        text.add("**Replied User:** [" & reply.get.from.get.firstName & "](tg://user?id=" & $reply.get.from.get.id & ") - `" & $reply.get.from.get.id & "`\n")
      if reply.get.sticker.isSome:
        text.add("**Sticker ID:** `" & reply.get.sticker.get.fileId & "`\n")
      if reply.get.photo.isSome:
        text.add("**Photo File ID:** `" & reply.get.photo.get.last.fileId & "`\n")
      if reply.get.forwardFromChat.isSome:
        text.add("**Forwarded From:** [" & reply.get.forwardFromChat.get.title & "](tg://user?id=" & $reply.get.forwardFromChat.get.id & ") - `" & $reply.get.forwardFromChat.get.id & "`\n")
      if reply.get.senderChat.isSome:
        text.add("**Replied Sender Chat:** [" & reply.get.senderChat.get.title & "](tg://user?id=" & $reply.get.senderChat.get.id & ") - `" & $reply.get.senderChat.get.id & "`\n")

    await ctx.reply(text, parseMode = "Markdown", disableWebPagePreview = true)
