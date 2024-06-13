try {
    // Try to import the correct package based on the major version of NodeJS
    const node_version = process.versions.node.split(".")[0];
    require('./node' + node_version + "x/newrelicinstrumentation.js")
} catch (error) {
    console.error(error)
}
