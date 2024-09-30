# Clear existing data
Transaction.destroy_all
Wallet.destroy_all
User.destroy_all
Team.destroy_all
Stock.destroy_all

# Create sample users
user1 = User.create!(email: "john.doe@example.com", name: "John Doe", password: "password", type: "user")
user2 = User.create!(email: "jane.smith@example.com", name: "Jane Smith", password: "password", type: "user")

# Create sample teams
team1 = User.create!(email: "alpha@example.com", name: "Alpha Team", password: "password", type: "team")
team2 = User.create!(email: "beta@example.com", name: "Beta Team", password: "password", type: "team")

# Create sample stocks
stock1 = User.create!(email: "apple@example.com", name: "Apple", password: "password")
stock1.type = 'stock'
stock1.save


stock2 = User.create!(email: "tesla@example.com", name: "Tesla", password: "password")
stock2.type = 'stock'
stock2.save

# Ensure wallets are created for all entities
user1_wallet = user1.wallet
user2_wallet = user2.wallet

team1_wallet = team1.wallet
team2_wallet = team2.wallet

stock1_wallet = stock1.wallet
stock2_wallet = stock2.wallet

# Credit some initial balance to each wallet
user1_wallet.update!(balance: 1000.0)
user2_wallet.update!(balance: 1500.0)

team1_wallet.update!(balance: 2000.0)
team2_wallet.update!(balance: 2500.0)


stock1_wallet.update!(balance: 4000.0)
stock2_wallet.update!(balance: 4500.0)
