#!/usr/bin/env node
const fs = require('fs')
const argv = require('minimist')(process.argv.slice(2), {
  alias: {
    c: 'country',
    d: 'district'
  }
})

const countries = JSON.parse(fs.readFileSync(argv.country));
const districts = JSON.parse(fs.readFileSync(argv.district));

const fixture = [];
districts.features.forEach(d => {
  const iso = d.properties.ISO2.toLowerCase();
  const country = countries.find(c => c.fields.iso.toLowerCase() === iso);
  if (!country) {
    console.log('Could not find', iso, d.properties.Admin01Nam);
    return;
  }
  fixture.push({
    model: 'api.District',
    pk: d.properties.OBJECTID,
    fields: {
      name: d.properties.Admin01Nam,
      code: d.properties.Admin01Cod,
      country: country.pk,
      country_iso: d.properties.ISO2,
      country_name: country.fields.name
    }
  });
});

fs.writeFileSync('./Districts.json', JSON.stringify(fixture));
