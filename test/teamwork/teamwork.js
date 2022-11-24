const { ethers } = require('hardhat');
const { expect } = require('chai');

describe('[Challenge] Truster', function () {
    let deployer, attacker, victim;

    const TOKENS_IN_POOL = ethers.utils.parseEther('1000000');

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, attacker, victim] = await ethers.getSigners();

        const DamnValuableToken = await ethers.getContractFactory('DamnValuableToken', deployer);
        const DamnValuableNFTFactory = await ethers.getContractFactory('DamnValuableNFT', deployer);
        
        this.token = await DamnValuableToken.deploy();
        this.nft = await DamnValuableNFTFactory.deploy();

        // await this.token.transfer(attacker, TOKENS_IN_POOL);

        await this.nft.safeMint(victim.address);
        const address = await this.nft.ownerOf(0);
        console.log(address);
        console.log(victim.address);

        // function ownerOf(uint256 tokenId) external view returns (address owner);

        // expect(
        //     await this.token.balanceOf(this.pool.address)
        // ).to.equal(TOKENS_IN_POOL);

        // expect(
        //     await this.token.balanceOf(attacker.address)
        // ).to.equal('0');
    });

    // it('Exploit', async function () {
    //     /** CODE YOUR EXPLOIT HERE  */
    //     const AttackTruster = await ethers.getContractFactory('AttackTruster');
        
    //     this.attack = await AttackTruster.connect(attacker).deploy(this.pool.address,this.token.address);
    //     await this.attack.connect(attacker).attack();
    //     await this.attack.connect(attacker).withdraw();
    // });

    // after(async function () {
    //     /** SUCCESS CONDITIONS */

    //     // Attacker has taken all tokens from the pool
    //     expect(
    //         await this.token.balanceOf(attacker.address)
    //     ).to.equal(TOKENS_IN_POOL);
    //     expect(
    //         await this.token.balanceOf(this.pool.address)
    //     ).to.equal('0');
    // });
});

