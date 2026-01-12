import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";

describe("Counter", async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();

  it("Should emit the Increment event when calling the inc() function", async function () {
    const counter = await viem.deployContract("Counter");

    await viem.assertions.emitWithArgs(
      counter.write.inc(),
      counter,
      "Increment",
      [1n, 1n], // by, newValue
    );
  });

  it("The sum of the Increment events should match the current value", async function () {
    const counter = await viem.deployContract("Counter");
    const deploymentBlockNumber = await publicClient.getBlockNumber();

    // run a series of increments
    for (let i = 1n; i <= 10n; i++) {
      await counter.write.incBy([i]);
    }

    const events = await publicClient.getContractEvents({
      address: counter.address,
      abi: counter.abi,
      eventName: "Increment",
      fromBlock: deploymentBlockNumber,
      strict: true,
    });

    // check that the aggregated events match the current value
    let total = 0n;
    for (const event of events) {
      total += event.args.by;
    }

    assert.equal(total, await counter.read.x());
  });

  it("Should emit the Decrement event when calling the dec() function", async function () {
    const counter = await viem.deployContract("Counter");

    // First increment to have a value to decrement
    await counter.write.inc();

    await viem.assertions.emitWithArgs(
      counter.write.dec(),
      counter,
      "Decrement",
      [1n, 0n], // by, newValue
    );
  });

  it("The value should correctly reflect increments and decrements", async function () {
    const counter = await viem.deployContract("Counter");
    const deploymentBlockNumber = await publicClient.getBlockNumber();

    // run a series of increments
    for (let i = 1n; i <= 5n; i++) {
      await counter.write.incBy([i]);
    }

    // run a series of decrements
    for (let i = 1n; i <= 3n; i++) {
      await counter.write.decBy([i]);
    }

    // Get all increment events
    const incrementEvents = await publicClient.getContractEvents({
      address: counter.address,
      abi: counter.abi,
      eventName: "Increment",
      fromBlock: deploymentBlockNumber,
      strict: true,
    });

    // Get all decrement events
    const decrementEvents = await publicClient.getContractEvents({
      address: counter.address,
      abi: counter.abi,
      eventName: "Decrement",
      fromBlock: deploymentBlockNumber,
      strict: true,
    });

    // Calculate net value
    let total = 0n;
    for (const event of incrementEvents) {
      total += event.args.by;
    }
    for (const event of decrementEvents) {
      total -= event.args.by;
    }

    assert.equal(total, await counter.read.x());
  });

  it("Should have deployer as owner", async function () {
    const [deployer] = await viem.getWalletClients();
    const counter = await viem.deployContract("Counter");
    
    const owner = await counter.read.owner();
    assert.equal(owner.toLowerCase(), deployer.account.address.toLowerCase());
  });

  it("Should emit DataStored event when owner stores data", async function () {
    const counter = await viem.deployContract("Counter");
    const deploymentBlockNumber = await publicClient.getBlockNumber();
    
    await counter.write.storeData(["test data"]);
    
    const events = await publicClient.getContractEvents({
      address: counter.address,
      abi: counter.abi,
      eventName: "DataStored",
      fromBlock: deploymentBlockNumber,
      strict: true,
    });
    
    assert.equal(events.length, 1);
    // Since data is indexed, it's hashed. We verify the event was emitted with a timestamp
    assert.ok(events[0].args.timestamp > 0n);
    // Verify we can access the indexed data (it will be a hash)
    assert.ok(events[0].args.data !== undefined);
  });

  it("Should revert when non-owner tries to store data", async function () {
    const counter = await viem.deployContract("Counter");
    const [_, nonOwner] = await viem.getWalletClients();
    
    await assert.rejects(
      async () => {
        await counter.write.storeData(["test data"], {
          account: nonOwner.account,
        });
      },
      (error: any) => {
        return error.message.includes("Unauthorized") || error.message.includes("revert");
      }
    );
  });

  it("Should reset counter when owner calls reset", async function () {
    const counter = await viem.deployContract("Counter");
    
    // Increment first
    await counter.write.inc();
    await counter.write.incBy([5n]);
    assert.equal(await counter.read.x(), 6n);
    
    // Reset
    await counter.write.reset();
    assert.equal(await counter.read.x(), 0n);
  });

  it("Should allow owner to transfer ownership", async function () {
    const counter = await viem.deployContract("Counter");
    const [deployer, newOwner] = await viem.getWalletClients();
    
    const initialOwner = await counter.read.owner();
    assert.equal(initialOwner.toLowerCase(), deployer.account.address.toLowerCase());
    
    await counter.write.transferOwnership([newOwner.account.address]);
    
    const finalOwner = await counter.read.owner();
    assert.equal(finalOwner.toLowerCase(), newOwner.account.address.toLowerCase());
  });

  it("Should revert when non-owner tries to transfer ownership", async function () {
    const counter = await viem.deployContract("Counter");
    const [_, nonOwner, anotherAccount] = await viem.getWalletClients();
    
    await assert.rejects(
      async () => {
        await counter.write.transferOwnership([anotherAccount.account.address], {
          account: nonOwner.account,
        });
      },
      (error: any) => {
        return error.message.includes("Unauthorized") || error.message.includes("revert");
      }
    );
  });
});
