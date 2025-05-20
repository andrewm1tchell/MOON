I Am Where You Aren't
![I_Am_Where_You_Aren't 5](https://github.com/user-attachments/assets/828971b4-4ff5-4275-aa21-059b8b6a9de2)
![I_Am_Where_You_Aren't 6](https://github.com/user-attachments/assets/6e6cd74d-13bb-4dbf-8a32-3342547554af)

Main Manifold contract containing the NFT:


IAWYAExtension.sol containing the Onchain TokenURI:
[0xd3fD133460a4E8292CB7C1aA7984704B23857d59](https://etherscan.io/address/0x5D33bf955F46Cf194ae742d5A1A6f4ADC50f118e)

FlipEngine.sol containing the images and the flip functionality:
[0x75122C1ED275ce3D00f34AE592928bD7180f928C](https://etherscan.io/address/0x457b961794d9F1037C63c3dd09E588Cb93567FAa)


How does the TokenURI work?
TokenURI() is called -> Manifold Contract -> IAWYAExtension.sol -> FlipEngine.sol 
This contracts creates a JSON object with the image, animationUrl, description, and title.

To flip the image, you must own the NFT and then you can call "flip" in the IAWYAExtension.sol.

Alternatively you can interact with the token on a webpage on ARWEAVE her:
https://bgl3rm5ok7cpz6y7x4a23zpfmk2ljnooil6nh3lavr335ttv6q7q.arweave.net/CZe4s65XxPz7H78BreXlYrS0tc5C_NPtYKx3vs519D8

All of the contracts work together to build out the tokenURI JSON object, which is encoded into Base 64 onchain.

