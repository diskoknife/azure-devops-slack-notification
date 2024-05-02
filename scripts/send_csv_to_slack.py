from slack_sdk import WebClient
import os

csv_file=os.getenv("CSV_OUTPUT_FILE")

# In App directory you should check if bot token is available, if not provide the docs
slack_bot_token = os.getenv("SLACK_BOT_TOKEN")

# Simply starting one session
client = WebClient(token=slack_bot_token)

# Define the channel where you want to upload the file
channel_id = os.getenv("SLACK_CHANNEL_ID")


# Check if csv exists
if not os.path.exists(csv_file):
    print("File not found.")
    exit()

# Upload the file
try:
    response = client.files_upload(
        channels=channel_id,
        file=csv_file
    )
    print("File uploaded successfully!")
    print(response)
except Exception as e:
    print(f"Error uploading file: {str(e)}")