MOON, a collaboration with artist omentejovem
<img width="2048" height="1536" alt="image" src="https://github.com/user-attachments/assets/a499366f-bae8-4a77-aba9-cc30f9bb774a" />
<img width="1000" height="750" alt="image" src="https://github.com/user-attachments/assets/fceb540f-262a-4001-9e07-0f6828963c10" />


Main Manifold contract containing the NFT:


Moon.sol containing the Onchain TokenURI:
[0xfF4aC906ef9493B4D22248d239e2905DA321574F](https://etherscan.io/address/0xfF4aC906ef9493B4D22248d239e2905DA321574F)

FlipEngine.sol containing the images and the flip functionality:
[0x05EC1c0D5D8B2A3bAAb1CD84Bd822EDaa4ce074f](https://etherscan.io/address/0x05EC1c0D5D8B2A3bAAb1CD84Bd822EDaa4ce074f)


How does the TokenURI work?
TokenURI() is called -> Manifold Contract -> Moon.sol -> FlipEngine.sol 
This contracts creates a JSON object with the image, animationUrl, description, and title.

To flip the image, you must own the NFT and then you can call "flip" in the MoonExtension.sol.

Alternatively you can interact with the token on a webpage on ARWEAVE her:
https://qbg4okm3bwvjbgrn6hvthh7kdihwrxlzlzfnv2y5o3x4bkoksjyq.ardrive.net/gE3HKZsNqpCaLfHrM5_qGg9o3XleStrrHXbvwKnKknE?

All of the contracts work together to build out the tokenURI JSON object, which is encoded into Base 64 onchain.

