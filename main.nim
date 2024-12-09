import asynctools, telegrambot, modules/pin, modules/locks, modules/admin, modules/afk, modules/filters, modules/greetings, modules/ban, modules/id, db
import config

let bot = newBot(config.BOT_TOKEN)

proc setupBot() =
  registerPinCommands(bot)
  registerLockCommands(bot)
  registerAdminCommands(bot)
  registerFilterCommands(bot)
  registerGreetingCommands(bot)
  registerBanCommands(bot)
  registerAFKCommands(bot)
  registerIDCommand(bot)

proc main() {.async.} =
  await bot.start()
  setupBot()
  await bot.idle()

when isMainModule:
  asyncCheck main()
