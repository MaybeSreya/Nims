import asynctools, telegrambot, modules/pin, modules/locks, modules/admin, db
import config

let bot = newBot(config.BOT_TOKEN)

proc setupBot() =
  registerPinCommands(bot)
  registerLockCommands(bot)
  registerAdminCommands(bot)

proc main() {.async.} =
  await bot.start()
  setupBot()
  await bot.idle()

when isMainModule:
  asyncCheck main()
