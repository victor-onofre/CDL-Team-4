### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 48464f80-de88-11eb-003c-23eec447aadd
using PastaQ

# ╔═╡ b43c2cf8-46be-45e9-b665-fe63c422059f
using Plots

# ╔═╡ 90ad7498-318b-44cd-b115-403236feb775
plotly()

# ╔═╡ f7199713-4706-4d56-8934-12555a72b02b
md"""
We can create the gates
"""

# ╔═╡ ebdc68cf-54d4-436a-b8c6-fd0bd3a86e78
function PastaQ.gate(::GateName"R"; theta::Real, phi::Real)
	[
		cos(theta/2)	(-im * exp(-im * phi) * sin(theta/2))
		(-im * exp(im * phi) * sin(theta/2))	cos(theta/2)
	]
end

# ╔═╡ 17e51f98-8fcb-485c-8024-57a74e2e0d2b
function PastaQ.gate(::GateName"M"; Theta::Real)
	[
		cos(Theta)	0 	0 	(-im * sin(Theta))
		0 	cos(Theta)	(-im * sin(Theta))	0
		0 	(-im * sin(Theta))	cos(Theta)	0
		(-im * sin(Theta))	0 	0 	cos(Theta)
	]
end

# ╔═╡ 0dacb284-a62b-48c8-91be-e0a76af1ec5a
function run(N, depth)
	#random circuit.
	gates = Vector{Tuple}[]
	
	for i in 1:depth 
		one_qubit_layer = Tuple[]
		two_qubit_layer = Tuple[]
		
		for j in 1:N
			gate = ("R", j, (theta=2*pi*rand(), phi=2pi*rand()))
			push!(one_qubit_layer, gate)
		end
		
		# Alternate start qubit for pairs
		idx_first = i % 2 + 1
		
		for j in idx_first:2:(N-1)
			gate = ("M", (j, j+1), (Theta=2pi*rand(),))
			push!(two_qubit_layer, gate)
		end
		
		push!(gates, one_qubit_layer)
		push!(gates, two_qubit_layer)
	end
	
	ψ = runcircuit(N, gates)
	getsamples(ψ,100)
end

# ╔═╡ ae2c2bd3-b454-44ff-a87c-fac45b25a442
N = 4

# ╔═╡ ddf920bc-0633-4c61-b765-d36dc5128e0b
depth = 4

# ╔═╡ ff19e11c-131c-4dd1-b757-c2dfffff68f9
saida = run(N,depth)

# ╔═╡ 6376135b-8792-4d91-be52-96664d9c27dd
saida[1:3,:]

# ╔═╡ 2abf0132-db09-4b0f-b94d-508e171004e3
cumsum(saida,dims=1)[100,:]/100

# ╔═╡ 505e2b4f-bfe7-4669-849b-acd9420b3be0
bar(cumsum(saida,dims=1)[100,:]/100)

# ╔═╡ 8b4d668c-7513-45e4-a982-1c2d10f6255d
scatter(1:4,repeat([1],4),ylim=(0.85,1.15),ms=20*cumsum(saida,dims=1)[100,:]/100)

# ╔═╡ 46f30455-fd17-4070-833c-d50dbf9a34d4
tt = reverse(digits(9; base=2, pad=4))

# ╔═╡ 2094233b-2e98-4d12-b6ae-f17e05b11a88
prod(string.(reverse(digits(9; base=2, pad=N))))

# ╔═╡ b1c05fff-344e-42fe-9c84-0530dc892934
numbers_bin = []

# ╔═╡ b5b2a823-dbf5-4c5b-8003-af329c6cebdd
map(1:2^N) do i
	out = reverse(digits(i; base=2, pad=4))
	push!(numbers_bin, out)
	md"bit-string for $i is $out"
end

# ╔═╡ 944cbcad-8e8a-4c0a-bd4c-c5b73f4e46ce
starting_state = [tt[n] == 1 ? ("X", n) : ("I", n) for n in 1:N]

# ╔═╡ 4e1a5767-32cf-4da7-98c9-f422a13bf04f
starting_state

# ╔═╡ 8895f8bf-c592-4b11-a21f-8a0ea13cb612
ψ0 = qubits(N)

# ╔═╡ 524b4ea8-30bd-496a-a342-124d3490a42b
ψ1 = runcircuit(ψ0, starting_state)

# ╔═╡ 05d9c82d-914d-42f9-955a-bda067126681
samples = getsamples(ψ1,10)

# ╔═╡ Cell order:
# ╠═48464f80-de88-11eb-003c-23eec447aadd
# ╠═b43c2cf8-46be-45e9-b665-fe63c422059f
# ╠═90ad7498-318b-44cd-b115-403236feb775
# ╠═f7199713-4706-4d56-8934-12555a72b02b
# ╠═ebdc68cf-54d4-436a-b8c6-fd0bd3a86e78
# ╠═17e51f98-8fcb-485c-8024-57a74e2e0d2b
# ╠═0dacb284-a62b-48c8-91be-e0a76af1ec5a
# ╠═ae2c2bd3-b454-44ff-a87c-fac45b25a442
# ╠═ddf920bc-0633-4c61-b765-d36dc5128e0b
# ╠═ff19e11c-131c-4dd1-b757-c2dfffff68f9
# ╠═6376135b-8792-4d91-be52-96664d9c27dd
# ╠═2abf0132-db09-4b0f-b94d-508e171004e3
# ╠═505e2b4f-bfe7-4669-849b-acd9420b3be0
# ╠═8b4d668c-7513-45e4-a982-1c2d10f6255d
# ╠═46f30455-fd17-4070-833c-d50dbf9a34d4
# ╠═2094233b-2e98-4d12-b6ae-f17e05b11a88
# ╠═b1c05fff-344e-42fe-9c84-0530dc892934
# ╠═b5b2a823-dbf5-4c5b-8003-af329c6cebdd
# ╠═944cbcad-8e8a-4c0a-bd4c-c5b73f4e46ce
# ╠═4e1a5767-32cf-4da7-98c9-f422a13bf04f
# ╠═8895f8bf-c592-4b11-a21f-8a0ea13cb612
# ╠═524b4ea8-30bd-496a-a342-124d3490a42b
# ╠═05d9c82d-914d-42f9-955a-bda067126681
