const { expect } = require("chai");

function sleep(milliseconds) {
  const date = Date.now();
  let currentDate = null;
  do {
    currentDate = Date.now();
  } while (currentDate - date < milliseconds);
}

describe("Lotto contract", function() {
  it("Lotto contract", async function() {
    let Lotto;
    let lotto;
    let addr1;
    let addr2;
    let addr3;

    Lotto = await ethers.getContractFactory("Lotto");
    [addr1, addr2, addr3] = await ethers.getSigners();

    lotto = await Lotto.deploy();

    describe("Entries", function() {
      it("Total should be 600, equivalent of individual stakes of 200 + 400", async function() {
        await lotto.connect(addr1).enter(200);

        await lotto.connect(addr2).enter(400);

        let oneStake = await lotto.connect(addr1).getStakedAmount();
        let twoStake = await lotto.connect(addr2).getStakedAmount();

        expect(await lotto.getTotalStaked()).to.equal(parseInt(oneStake) + parseInt(twoStake));
      });
    })

    describe("Exits", function() {
      it("Remove 100 from each and find new total amount of 400", async function() {
        await lotto.connect(addr1).exit(100);
        await lotto.connect(addr2).exit(100);

        let oneStake = await lotto.connect(addr1).getStakedAmount();
        let twoStake = await lotto.connect(addr2).getStakedAmount();

        expect(await lotto.getTotalStaked()).to.equal(parseInt(oneStake) + parseInt(twoStake));
      })

      it("exit of 100 for addr3 should fail", async function() {
        await expect(lotto.connect(addr3).exit(100)).to.be.revertedWith("cannot exit with balance 0 or amount 0");
      })
    })
  })

  describe("Shares and Relative Shares", function() {
    it("find Share per ")
  })
});
