import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Reputation", function () {
  const deployFixture = async () => {
    const [owner, other] = await ethers.getSigners();

    const tokenData = {
      _name: "Test Token",
      _symbol: "TT",
      _decimals: 18,
      _owner: owner.address,
      _transferable: true,
      _burnable: true
    }

    const ReputationToken = await ethers.getContractFactory("ReputationToken");
    const reputationToken = await ReputationToken.deploy();
    await reputationToken.initialize(
      tokenData._name,
      tokenData._symbol,
      tokenData._decimals,
      tokenData._owner,
      tokenData._transferable,
      tokenData._burnable
    );

    await reputationToken.mint(other.address, 1000);
    await reputationToken.mint(owner.address, 1000);

    const TokenFactory = await ethers.getContractFactory("ReputationTokenFactory");
    const tokenFactory = await TokenFactory.deploy();
    await tokenFactory.initialize(owner.address);

    return { reputationToken, tokenFactory, owner, other, tokenData };
  }

  describe("ReputationTokenFactory", function () {
    it("Should create a new token", async function () {
      const { tokenFactory, owner, tokenData } = await loadFixture(deployFixture);

      expect(
        await tokenFactory.create(
          tokenData._name,
          tokenData._symbol,
          tokenData._decimals,
          tokenData._owner,
          tokenData._transferable,
          tokenData._burnable
        )
      ).to.emit(tokenFactory, "TokenCreated").withArgs(owner.address, 1);
    });

    it("Should have the correct parameters", async function () {
      const { tokenFactory, owner, tokenData } = await loadFixture(deployFixture);

      const tx = await tokenFactory.create(
        tokenData._name,
        tokenData._symbol,
        tokenData._decimals,
        tokenData._owner,
        tokenData._transferable,
        false
      );

      const tkn = (await tx.wait())?.events?.[0].args?.token;
      console.log(tkn)
      const reputationToken = await ethers.getContractAt("ReputationToken", tkn);

      expect(await reputationToken.name()).to.equal(tokenData._name);
      expect(await reputationToken.symbol()).to.equal(tokenData._symbol);
      expect(await reputationToken.decimals()).to.equal(tokenData._decimals);
      expect(await reputationToken.owner()).to.equal(tokenData._owner);
      expect(await reputationToken.transferable()).to.equal(tokenData._transferable);
      expect(await reputationToken.burnable()).to.equal(false);

    });
  });

  describe("ReputationToken", function () {
    it("Should return the correct name", async function () {
      const { reputationToken, tokenData } = await loadFixture(deployFixture);

      expect(await reputationToken.name()).to.equal(tokenData._name);
    });

    it("Should return the correct symbol", async function () {
      const { reputationToken, tokenData } = await loadFixture(deployFixture);

      expect(await reputationToken.symbol()).to.equal(tokenData._symbol);
    });

    it("Should return the correct decimals", async function () {
      const { reputationToken, tokenData } = await loadFixture(deployFixture);

      expect(await reputationToken.decimals()).to.equal(tokenData._decimals);
    });

    it("Should return the correct owner", async function () {
      const { reputationToken, owner } = await loadFixture(deployFixture);

      expect(await reputationToken.owner()).to.equal(owner.address);
    });

    it("Should return the correct transferable", async function () {
      const { reputationToken, tokenData } = await loadFixture(deployFixture);

      expect(await reputationToken.transferable()).to.equal(tokenData._transferable);
    });

    it("Should return the correct burnable", async function () {
      const { reputationToken, tokenData } = await loadFixture(deployFixture);

      expect(await reputationToken.burnable()).to.equal(tokenData._burnable);
    });
  });

  describe("ReputationToken: restrictions", function () {
    it("Owner can mint token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await reputationToken.mint(other.address, 100);
      expect(await reputationToken.balanceOf(other.address)).to.equal(1100);
    });

    it("Owner can mintMany token", async function () {
      const { reputationToken, other, owner } = await loadFixture(deployFixture);

      const mintData = [
        { account: other.address, amount: 100 },
        { account: owner.address, amount: 100 },
      ]
      await reputationToken.mintMany(mintData);
      expect(await reputationToken.balanceOf(other.address)).to.equal(1100);
      expect(await reputationToken.balanceOf(owner.address)).to.equal(1100);
    });

    it("Owner can burn token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await reputationToken.burn(other.address, 100);
      expect(await reputationToken.balanceOf(other.address)).to.equal(900);
    });

    it("Owner can set transferable", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await reputationToken.setTransferable(false);
      expect(await reputationToken.transferable()).to.equal(false);
    });

    it("User cannot mint token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await expect(
        reputationToken.connect(other).mint(other.address, 100)
      ).to.reverted;
    });

    it("User cannot mintMany token", async function () {
      const { reputationToken, other, owner } = await loadFixture(deployFixture);

      const mintData = [
        { account: other.address, amount: 100 },
        { account: owner.address, amount: 100 },
      ]
      await expect(
        reputationToken.connect(other).mintMany(mintData)
      ).to.reverted;
    });

    it("User cannot burn token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await expect(
        reputationToken.connect(other).burn(other.address, 100)
      ).to.reverted;
    });

    it("User cannot set transferable", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await expect(
        reputationToken.connect(other).setTransferable(false)
      ).to.reverted;
    });
  });

  describe("ReputationToken: transferable true", function () {
    it("Owner can mint token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await reputationToken.mint(other.address, 100);
      expect(await reputationToken.balanceOf(other.address)).to.equal(1100);
    });

    it("User can transfer token", async function () {
      const { reputationToken, owner, other } = await loadFixture(deployFixture);

      expect(
        await reputationToken.transfer(other.address, 100)
      ).to.emit(reputationToken, "Transfer").withArgs(reputationToken.address, other.address, 100);

      expect(await reputationToken.balanceOf(other.address)).to.equal(1100);
      expect(await reputationToken.balanceOf(owner.address)).to.equal(900);
    });

  });

  describe("ReputationToken: transferable false", function () {
    it("Owner can mint token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);
      await reputationToken.setTransferable(false);

      await reputationToken.mint(other.address, 100);
      expect(await reputationToken.balanceOf(other.address)).to.equal(1100);
    });

    it("User can not transfer token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);
      await reputationToken.setTransferable(false)

      await expect(
        reputationToken.transfer(other.address, 100)
      ).to.reverted;
    });
  });

  describe("ReputationToken: burnable true", function () {
    it("Owner can burn token", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      await reputationToken.burn(other.address, 100);
      expect(await reputationToken.balanceOf(other.address)).to.equal(900);
    });

    it("Total supply should decrease", async function () {
      const { reputationToken, other } = await loadFixture(deployFixture);

      const totalSupplyBefore = await reputationToken.totalSupply();
      await reputationToken.burn(other.address, 100);
      expect(await reputationToken.totalSupply()).to.equal(totalSupplyBefore.sub(100));
    });

  });

  describe("ReputationToken: burnable false", function () {
    it("Owner can not burn token", async function () {
      const { tokenFactory, owner, tokenData } = await loadFixture(deployFixture);

      const tx = await tokenFactory.create(
        tokenData._name,
        tokenData._symbol,
        tokenData._decimals,
        tokenData._owner,
        tokenData._transferable,
        false
      );

      const tkn = (await tx.wait())?.events?.[0].args?.token;
      const reputationToken = await ethers.getContractAt("ReputationToken", tkn);

      await expect(
        reputationToken.burn(owner.address, 100)
      ).to.reverted;
    });

  });

});