#!/bin/sh

cd $1

mix deps.get
mix deps.compile
mix compile
mix test --formatter MustrumTester.ExUnitFormatter