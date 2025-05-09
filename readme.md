Moon
![Light](https://github.com/user-attachments/assets/4ea887cf-b761-4c54-9f38-f756634b968b)
![Dark](https://github.com/user-attachments/assets/78d38fef-077a-400c-a572-cf4d7aeefdf9)

There are 2 contracts involved in Moon.

Main Manifold contract containing the NFT:
0xfda33af4770d844dc18d8788c7bf84accfac79ad

Moon Contract containing the Onchain TokenURI and Onchain preview image:
0xd3fD133460a4E8292CB7C1aA7984704B23857d59

MoonEngine containing the images and the flip functionality:
0x75122C1ED275ce3D00f34AE592928bD7180f928C


How does the TokenURI work?
TokenURI() is called -> Manifold Contract -> Moon Contract 
This contracts creates a JSON object with the image, animationUrl, description, and title.
To get the image, we utilize MoonEngine.
To flip the image, you must own the NFT and then you can call "flip" in the MoonEngine.

All of the contracts work together to build out the tokenURI JSON object, which is encoded into Base 64 onchain.

