//
//  BeeKind.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 30.06.24.
//

import Foundation

enum BeeKind: String, CaseIterable, Identifiable {
    case honeyBee = "Honey Bee"
    case bumbleBee = "Bumble Bee"
    case carpenterBee = "Carpenter Bee"
    case masonBee = "Mason Bee"
    case leafcutterBee = "Leafcutter Bee"
    case sweatBee = "Sweat Bee"
    case miningBee = "Mining Bee"
    case cuckooBee = "Cuckoo Bee"
    case woolCarderBee = "Wool Carder Bee"
    case alkaliBee = "Alkali Bee"
    case longHornedBee = "Long-Horned Bee"
    case tawnyMiningBee = "Tawny Mining Bee"
    case cuckooBumblebee = "Cuckoo Bumblebee"
    case hawkMothBee = "Hawk Moth Bee"
    case pollenBee = "Pollen Bee"
    case diggerBee = "Digger Bee"
    case europeanHoneyBee = "European Honey Bee"
    case blueOrchardBee = "Blue Orchard Bee"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var imageName: String {
        self.rawValue
    }
    
    var wedgitDescription: String {
        switch self {
        case .honeyBee:
            return "Honey bees (Apis mellifera) are remarkable for their ability to produce honey and their complex social structures."
        case .bumbleBee:
            return "Bumble bees (Bombus spp.) are large, hairy bees known for their role in pollinating wildflowers and crops."
        case .carpenterBee:
            return "Carpenter bees (Xylocopa spp.) are solitary bees known for their nesting behavior in wood."
        case .masonBee:
            return "Mason bees (Osmia spp.) are solitary bees known for their nesting behavior using mud or other materials to construct their nests."
            
        case .leafcutterBee:
            return "Leafcutter bees (Megachile spp.) are solitary bees known for their unique behavior of cutting circular pieces from leaves to construct their nests."
        case .sweatBee:
            return "Sweat bees (Halictidae family) are small, metallic-looking bees that are attracted to human sweat for its moisture and salts."
            
        case .miningBee:
            return "Mining bees (Andrena spp.) are solitary bees that create nests by digging tunnels in the ground."
        case .cuckooBee:
            return "Cuckoo bees (Nomada spp.) are parasitic bees that lay their eggs in the nests of other bee species."
        case .woolCarderBee:
            return "Wool carder bees (Anthidium spp.) are solitary bees known for their unique behavior of carding plant fibers to line their nests."
        case .alkaliBee:
            return "Alkali bees (Nomia spp.) are important pollinators for crops such as alfalfa."
        case .longHornedBee:
            return "Long-horned bees (Eucera spp.) are solitary bees recognized by their long antennae."
        case .tawnyMiningBee:
            return "Tawny mining bees (Andrena fulva) are solitary bees known for their burrowing behavior in sandy soils."
        case .cuckooBumblebee:
            return "Cuckoo bumblebees (Bombus spp.) are parasitic bees that lay their eggs in the nests of other bumblebee species."
        case .hawkMothBee:
            return "Hawk moth bees (Anthophora plumipes) are solitary bees that are often mistaken for hawk moths due to their large size and rapid wing movement."
        case .pollenBee:
            return "Pollen bees (Melitoma spp.) are solitary bees that are known for their efficient pollen collection."
        case .diggerBee:
            return "Digger bees (Anthophora spp.) are solitary bees known for their burrowing behavior in the ground."
        case .europeanHoneyBee:
            return "European honey bees (Apis mellifera) are a subspecies of honey bees known for their significant role in agriculture and honey production."
        case .blueOrchardBee:
            return    "Blue orchard bees (Osmia lignaria) are solitary bees known for their striking blue color and their role as effective pollinators of fruit trees, particularly orchards."
        case .other:
            return "The other category encompasses a diverse range of bee species with unique behaviors and characteristics that do not fall into the more commonly known categories."
        }
    }
    
    var description: String {
        switch self {
        case .honeyBee:
            return """
            Honey bees (Apis mellifera) are remarkable for their ability to produce honey and their complex social structures. They live in large colonies that include a single queen, thousands of worker bees, and a few drones. The hive is a highly organized society where each member has specific roles and responsibilities. Honey bees are vital for pollinating many agricultural crops and wild plants, which makes them crucial for food production and ecosystem health.
            
            ** Lifespan:**
            Worker honey bees typically live for about 5-7 weeks during the active season, with the queen living up to 3-5 years. Drones have a much shorter lifespan, generally only a few weeks.
            
            ** Diet:**
            Honey
            bees feed on nectar and pollen. Nectar is converted into honey, which serves as the colony's primary food source. Pollen provides essential proteins and other nutrients needed for the development of larvae and the maintenance of hive health.
            
            ** Sleep:**
            Worker bees take numerous short naps throughout the day, with each nap lasting from a few seconds to a minute. Queens and drones have longer periods of inactivity, especially during winter.
            
            ** Allergies:**
            Honey bee stings can cause a range of reactions from mild irritation to severe anaphylaxis. Those with known bee sting allergies should carry an epinephrine auto-injector and seek immediate medical attention if stung.
            
            ** Ecological Impact:**
            Honey bees play a critical role in pollinating a wide variety of crops and wild plants. Their foraging activities contribute to the reproduction of plants, which supports biodiversity and agricultural productivity.
            
            ** Conservation:**
            To support honey bee populations, it is essential to reduce pesticide use, promote biodiversity, and support sustainable beekeeping practices. Planting diverse flowering plants and creating habitats that provide food and nesting opportunities can also enhance their survival and health.
            
            ** Sources:**
            
            - [National Honey Board]
            (https://www.honey.com/)
            
            - [Honeybee Conservancy]
            (https://honeybeeconservancy.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            """
        case .bumbleBee:
            return """
            Bumble bees (Bombus spp.) are large, hairy bees known for their role in pollinating wildflowers and crops. They have a distinctive buzzing sound due to their rapid wing movement and are capable of buzz pollination, a technique where they vibrate their flight muscles to release pollen from flowers. Bumble bee colonies are smaller than those of honey bees and only last for a single season, with new queens emerging to start the cycle anew.
            
            ** Lifespan:**
            Worker bumble bees live for a few weeks, while queens can survive up to a year. The colony's lifespan is limited to the active season, with new queens overwintering to start new colonies the following year.
            
            ** Diet:**
            Bumble bees feed on nectar and pollen, which they collect and store in their nests. Their diet is crucial for providing energy for their activities and supporting larval development.
            
            ** Sleep:**
            Bumble bees rest in their nests, where they also sleep during periods of bad weather. Their sleep patterns include longer periods of rest compared to honey bees.
            
            ** Allergies:**
            Bumble bee stings can cause allergic reactions similar to honey bee stings. Although bumble bees are less aggressive and can sting multiple times, their venom can still trigger severe allergic responses in some individuals.
            
            ** Ecological Impact:**
            Bumble bees are important for the pollination of many wildflowers and crops, including those that are essential for food production. Their ability to pollinate a wide range of plants supports ecosystem health and biodiversity.
            
            ** Conservation:**
            Protecting bumble bee populations involves preserving their natural habitats, reducing pesticide use, and planting diverse flowering plants. Ensuring the availability of nesting sites and food resources is also important for their conservation.
            
            ** Sources:**
            
            - [Bumblebee Conservation Trust]
            (https://www.bumblebeeconservation.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            """
        case .carpenterBee:
            return """
            Carpenter bees (Xylocopa spp.) are solitary bees known for their nesting behavior in wood. They create tunnels in wooden structures to lay their eggs and store food for their larvae. Despite their intimidating size and appearance, carpenter bees are generally not aggressive and play a role in pollinating a variety of plants.
            
            ** Lifespan:**
            Carpenter bees typically live for about a year. Most of their life is spent in hibernation during the winter months, with their active period being during the warmer seasons.
            
            ** Diet:** Carpenter bees feed on nectar and occasionally pollen. Unlike honey bees, carpenter bees do not produce honey and primarily rely on nectar for their energy needs.
            
            ** Sleep:**
            Carpenter bees often rest inside their wooden nests or in sheltered areas. Their sleep patterns include longer periods of inactivity compared to social bees.
            
            ** Allergies:**
            Carpenter bee stings are rare, but when they do occur, they can cause allergic reactions ranging from local swelling to more severe responses. People with known bee venom allergies should exercise caution.
            
            ** Ecological Impact:**
            Carpenter bees contribute to the pollination of various flowering plants. Their nesting behavior can also impact wooden structures, but they play an important role in supporting plant reproduction.
            
            ** Conservation:**
            To protect carpenter bees, avoid using pesticide treatments on wooden structures and provide suitable nesting sites. Maintaining diverse plant life can also support their dietary needs.
            
            ** Sources:**
            
            - [Carpenter Bee Control]
            (https://www.carpenterbees.com/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            """
        case .masonBee:
            return """
            Mason bees (Osmia spp.) are solitary bees known for their nesting behavior using mud or other materials to construct their nests. They are highly effective pollinators, particularly for fruit trees and other flowering plants. Mason bees do not produce honey or beeswax but are essential for the pollination of various crops.
            
            ** Lifespan:**
            Mason bees typically live for about 6-8 weeks, mainly during the spring and early summer. After laying eggs and provisioning their nests, the adult bees die, and the larvae develop within the nests over the summer.
            
            ** Diet:**
            Mason bees feed on nectar and pollen, which they collect to provision their nests. They do not store food but collect what is needed for their offspring's development.
            
            ** Sleep:**
            Mason bees rest inside their nesting tubes or in sheltered areas. They are active during the day and rest at night or during adverse weather conditions.
            
            ** Allergies:**
            Mason bees are not aggressive and rarely sting. However, their stings can cause mild allergic reactions in sensitive individuals.
            
            ** Ecological Impact:**
            Mason bees are crucial for the pollination of fruit trees and other plants. Their efficiency in pollination supports the production of fruits and enhances biodiversity.
            
            ** Conservation:**
            To support mason bees, provide suitable nesting sites such as bee houses or tubes. Reducing pesticide use and planting a variety of flowering plants can also benefit these bees.
            
            ** Sources:**
            
            - [The Xerces Society]
            (https://xerces.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Mason Bee Conservation]
            (https://masonbees.com/)
            """
        case .leafcutterBee:
            return """
            Leafcutter bees (Megachile spp.) are solitary bees known for their unique behavior of cutting circular pieces from leaves to construct their nests. These bees are excellent pollinators and are particularly effective for plants like alfalfa. They carry pollen on their abdomens, unlike honey bees that use their legs for this purpose.
            
            ** Lifespan:**
            Leafcutter bees typically live for about 6-8 weeks, primarily during the summer months. Their life cycle includes foraging, nesting, and laying eggs before they die.
            
            ** Diet:**
            Leafcutter bees feed on nectar and pollen. They collect and store pollen within their nests to provide food for their larvae.
            
            ** Sleep:**
            Leafcutter bees rest inside their nests, which they seal with leaves. They are diurnal and are active during the day, resting at night.
            
            ** Allergies:**
            Leafcutter bee stings are uncommon and generally mild. However, as with other bee stings, allergic reactions can occur in sensitive individuals.
            
            ** Ecological Impact:**
            Leafcutter bees are important pollinators for various plants and crops. Their nesting behavior also helps in the decomposition of plant material, contributing to soil health.
            
            ** Conservation:**
            To support leafcutter bees, provide suitable nesting materials such as hollow plant stems or bee houses. Planting a variety of flowering plants and reducing pesticide use can also enhance their habitat.
            
            ** Sources:**
            
            - [Leafcutter Bee Research]
            (https://www.leafcutterbee.com/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            """
        case .sweatBee:
            return """
            Sweat bees (Halictidae family) are small, metallic-looking bees that are attracted to human sweat for its moisture and salts. They play a role in pollinating a variety of plants and can be solitary or communal, depending on the species. Despite their attraction to sweat, they are generally not aggressive.
            
            ** Lifespan:**
            Sweat bees have varied lifespans, ranging from a few weeks to several months, depending on the species and environmental conditions.
            
            ** Diet:**
            Sweat bees feed on nectar and pollen. Some species also obtain moisture from human sweat, which can be an additional source of nutrients.
            
            ** Sleep:**
            Sweat bees rest in their nests, which can be located in the ground or in wood. They are diurnal, being active during the day and resting at night.
            
            ** Allergies:**
            Sweat bee stings are typically mild and cause minor irritation. However, multiple stings or stings to sensitive areas can result in stronger reactions. Individuals with known bee sting allergies should exercise caution.
            
            ** Ecological Impact:**
            Sweat bees are important for the pollination of various plants, supporting both wild plant communities and agricultural crops. Their role in ecosystems helps maintain plant diversity and productivity.
            
            ** Conservation:**
            To support sweat bees, maintain a variety of flowering plants and provide habitats such as bare soil or wooden nesting sites. Reducing pesticide use and planting diverse plant species can also benefit these bees.
            
            ** Sources:**
            
            - [Bee Atlas]
            (https://www.beeatlas.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            """
        case .miningBee:
            return """
            Mining bees (Andrena spp.) are solitary bees that create nests by digging tunnels in the ground. They prefer sandy or loose soils and are often found in gardens, fields, and meadows. Mining bees are important pollinators, especially for early spring flowers.
            
            ** Lifespan:**
            Mining bees generally live for about 4-6 weeks, primarily during the spring. Their life cycle involves foraging, nesting, and laying eggs before they die.
            
            ** Diet:**
            Mining bees feed on nectar and pollen. They provision their nests with pollen to feed their larvae, but do not store food for themselves.
            
            ** Sleep:**
            Mining bees rest inside their burrows, especially at night and during adverse weather conditions. They are diurnal and are active during the day.
            
            ** Allergies:**
            Mining bee stings are rare and these bees are generally not aggressive. However, allergic reactions can occur, ranging from mild irritation to more severe responses in sensitive individuals.
            
            ** Ecological Impact:**
            Mining bees play a crucial role in pollinating early spring flowers, which supports the health of ecosystems and the availability of food resources for other wildlife.
            
            ** Conservation:**
            To support mining bees, preserve natural areas with sandy soils and reduce pesticide use. Providing bare soil areas for nesting and planting early-blooming flowers can also help their populations.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservation Trust]
            (https://www.bumblebeeconservation.org/)
            """
        case .cuckooBee:
            return """
            Cuckoo bees (Nomada spp.) are parasitic bees that lay their eggs in the nests of other bee species. The larvae of cuckoo bees consume the provisions stored by the host bee and may also eat the host's eggs or larvae. Cuckoo bees do not collect pollen or build their own nests.
            
            ** Lifespan:**
            Cuckoo bees typically live for about 4-6 weeks. Their primary focus during this time is to find and lay eggs in the nests of other bees.
            
            ** Diet:**
            Adult cuckoo bees feed on nectar. Their larvae rely on the food stores and larvae of their host bees for nourishment.
            
            ** Sleep:**
            Cuckoo bees rest in sheltered areas or inside host nests when possible. They are diurnal and are active during the day.
            
            ** Allergies:**
            Cuckoo bee stings are uncommon due to their relatively rare encounters with humans. When they do sting, reactions can vary from mild irritation to severe allergic responses in susceptible individuals.
            
            ** Ecological Impact:**
            Cuckoo bees influence the behavior and population dynamics of their host species. Although they do not directly pollinate plants, their parasitic behavior can impact the overall health of bee communities.
            
            ** Conservation:**
            Since cuckoo bees are dependent on the nests of other bees, protecting the habitats of their host species is crucial. Ensuring the availability of diverse nesting sites and reducing pesticide use can benefit both cuckoo bees and their hosts.
            
            ** Sources:**
            
            - [Bee Atlas]
            (https://www.beeatlas.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            """
        case .woolCarderBee:
            return """
            Wool carder bees (Anthidium spp.) are solitary bees known for their unique behavior of carding plant fibers to line their nests. They are effective pollinators and contribute to the health of various flowering plants. Wool carder bees are recognized for their industriousness and distinctive nest-building techniques.
            
            ** Lifespan:**
            Wool carder bees typically live for about 6-8 weeks during the summer months. Their life cycle includes foraging, nesting, and laying eggs before they die.
            
            ** Diet:**
            Wool carder bees feed on nectar and pollen, using their collected plant fibers to line their nests. This behavior provides insulation and protection for their larvae.
            
            ** Sleep:**
            Wool carder bees rest in their nests or in sheltered areas. They are active during the day and rest at night or during adverse weather conditions.
            
            ** Allergies:**
            Wool carder bees are not particularly aggressive, but their stings can cause allergic reactions in sensitive individuals. Reactions may vary from mild irritation to more severe responses.
            
            ** Ecological Impact:**
            Wool carder bees play an important role in pollinating a variety of plants. Their unique nesting behavior also contributes to the health of plant communities by supporting the reproduction of flowering species.
            
            ** Conservation:**
            To support wool carder bees, provide suitable nesting sites such as bee houses or natural plant fibers. Planting a range of flowering plants and reducing pesticide use can also benefit these bees.
            
            ** Sources:**
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
        case .alkaliBee:
            return """
            Alkali bees (Nomia spp.) are important pollinators for crops such as alfalfa. They nest in alkaline soils and are known for their solitary behavior. Alkali bees are efficient pollinators and contribute significantly to agricultural productivity.
            
            ** Lifespan:**
            Alkali bees usually live for about 6-8 weeks, primarily during the warmer months. Their life cycle includes foraging, nesting, and laying eggs before their adult phase ends.
            
            ** Diet:**
            Alkali bees feed on nectar and pollen, which they collect and use to provision their nests. They play a crucial role in pollinating crops and wild plants.
            
            ** Sleep:**
            Alkali bees rest in their nests, which are typically located in alkaline soils. They are diurnal and are active during the day.
            
            ** Allergies:**
            Alkali bee stings are rare, but they can cause allergic reactions in some individuals. Reactions can range from mild irritation to more severe responses in sensitive people.
            
            ** Ecological Impact:**
            Alkali bees are vital for the pollination of crops like alfalfa, which supports both agricultural productivity and ecosystem health. Their pollination activities help maintain plant diversity and productivity.
            
            ** Conservation:**
            To support alkali bee populations, preserve natural areas with alkaline soils and reduce pesticide use. Providing suitable nesting sites and planting a variety of flowering plants can also benefit these bees.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
        case .longHornedBee:
            return """
            Long-horned bees (Eucera spp.) are solitary bees recognized by their long antennae. They are effective pollinators of various wildflowers and often nest in the ground or in existing cavities. Their distinctive antennae help them in locating flowers and navigating their environment.
            
            ** Lifespan:**
            Long-horned bees typically live for a few weeks to several months, depending on the species and environmental conditions. Their life cycle involves foraging, nesting, and laying eggs.
            
            ** Diet:**
            Long-horned bees feed on nectar and pollen, which they collect for their offspring. Their diet supports their energy needs and contributes to their role as pollinators.
            
            ** Sleep:**
            Long-horned bees rest in their nests or in sheltered areas. They are active during the day and rest at night or during adverse weather conditions.
            
            ** Allergies:**
            Long-horned bee stings are uncommon and generally mild. However, allergic reactions can occur, ranging from minor irritation to more severe responses in sensitive individuals.
            
            ** Ecological Impact:**
            Long-horned bees are important pollinators for various flowering plants. Their role in pollination supports plant reproduction and ecosystem health.
            
            ** Conservation:**
            To support long-horned bees, provide suitable nesting sites such as bare soil or cavities. Planting a diverse range of flowering plants and reducing pesticide use can also benefit these bees.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
        case .tawnyMiningBee:
            return """
            Tawny mining bees (Andrena fulva) are solitary bees known for their burrowing behavior in sandy soils. They are important pollinators for early spring flowers and contribute to the health of various plant species. Tawny mining bees are characterized by their distinctive tawny-colored bodies.
            
            ** Lifespan:**
            Tawny mining bees typically live for about 4-6 weeks, primarily during the spring. Their life cycle includes foraging, nesting, and laying eggs before their adult phase ends.
            
            ** Diet:**
            Tawny mining bees feed on nectar and pollen, which they collect and use to provision their nests. Their diet supports their energy needs and plays a role in pollination.
            
            ** Sleep:**
            Tawny mining bees rest in their burrows or in sheltered areas. They are diurnal and are active during the day.
            
            ** Allergies:**
            Tawny mining bee stings are rare and generally cause mild irritation. Allergic reactions can vary from minor to more severe responses in sensitive individuals.
            
            ** Ecological Impact:**
            Tawny mining bees are crucial for the pollination of early spring flowers, supporting both wild plant communities and the health of ecosystems.
            
            ** Conservation:**
            To support tawny mining bees, preserve natural areas with sandy soils and reduce pesticide use. Providing suitable nesting sites and planting early-blooming flowers can also benefit these bees.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
        case .cuckooBumblebee:
            return """
            Cuckoo bumblebees (Bombus spp.) are parasitic bees that lay their eggs in the nests of other bumblebee species. The larvae of cuckoo bumblebees consume the provisions stored by the host bumblebees and may also eat the host's eggs or larvae. Cuckoo bumblebees do not contribute to the nest's upkeep or foraging activities.
            
            ** Lifespan:**
            Cuckoo bumblebees typically live for a few weeks to a few months, depending on the species and environmental conditions. Their primary focus is to find and lay eggs in the nests of host bumblebees.
            
            ** Diet:** Cuckoo bumblebees feed on nectar. Their larvae rely on the food stores and larvae of their host bumblebees for nourishment.
            
            ** Sleep:**
            Cuckoo bumblebees rest in sheltered areas or inside host nests when possible. They are diurnal and are active during the day.
            
            ** Allergies:**
            Cuckoo bumblebee stings are rare but can cause allergic reactions in sensitive individuals. Reactions can vary from mild irritation to more severe responses.
            
            ** Ecological
            :**
            Cuckoo bumblebees influence the behavior and population dynamics of their host species. Although they do not directly pollinate plants, their parasitic behavior can impact the overall health of bumblebee communities.
            
            ** Conservation:**
            Protecting the habitats of host bumblebees is crucial for the conservation of cuckoo bumblebees. Ensuring diverse and healthy bumblebee populations can help maintain the balance of these complex interactions.
            
            ** Sources:**
            
            - [Bumblebee Conservation Trust]
            (https://www.bumblebeeconservation.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            """
        case .hawkMothBee:
            return """
            Hawk moth bees (Anthophora plumipes) are solitary bees that are often mistaken for hawk moths due to their large size and rapid wing movement. They are effective pollinators of a variety of flowering plants and are known for their long proboscises, which allow them to access nectar from deep flowers.
            
            ** Lifespan:**
            Hawk moth bees typically live for a few weeks to a few months. Their life cycle includes foraging, nesting, and laying eggs before their adult phase ends.
            
            ** Diet:**
            Hawk moth bees feed on nectar and pollen, which they collect for their offspring. Their long proboscises are adapted for accessing nectar from deep flowers.
            
            ** Sleep:**
            Hawk moth bees rest in their nests or in sheltered areas. They are diurnal and are active during the day.
            
            ** Allergies:**
            Hawk moth bee stings are rare and generally mild. Allergic reactions can vary from minor irritation to more severe responses in sensitive individuals.
            
            ** Ecological Impact:**
            Hawk moth bees contribute to the pollination of a variety of flowering plants. Their role in supporting plant reproduction and ecosystem health is significant.
            
            ** Conservation:**
            To support hawk moth bees, provide suitable nesting sites such as bare soil or cavities. Planting a diverse range of flowering plants and reducing pesticide use can also benefit these bees.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
        case .pollenBee:
            return """
            Pollen bees (Melitoma spp.) are solitary bees that are known for their efficient pollen collection. They are important pollinators for a variety of flowering plants and contribute to the health of ecosystems. Pollen bees are characterized by their ability to carry large amounts of pollen on their bodies.
            
            ** Lifespan:**
            
            Pollen bees generally live for a few weeks to several months, depending on the species and environmental conditions. Their life cycle involves foraging, nesting, and laying eggs.
            
            ** Diet:**
            
            Pollen bees feed on nectar and pollen. They collect pollen from flowers to provision their nests and support the development of their larvae.
            
            ** Sleep:**
            
            Pollen bees rest in their nests or in sheltered areas. They are diurnal and are active during the day.
            
            ** Allergies:**
            
            Pollen bee stings are relatively rare and generally cause mild irritation. Allergic reactions can vary from minor to more severe responses in sensitive individuals.
            
            ** Ecological Impact:**
            
            Pollen bees are important for the pollination of a wide range of plants. Their role in supporting plant reproduction and ecosystem health is crucial.
            
            ** Conservation:**
            
            To support pollen bees, provide suitable nesting sites and reduce pesticide use. Planting a diverse range of flowering plants and maintaining natural habitats can also benefit these bees.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
        case .diggerBee:
            return """
            Digger bees (Anthophora spp.) are solitary bees known for their burrowing behavior in the ground. They are important pollinators for various flowering plants and are characterized by their ability to create nests by digging tunnels in the soil.
            
            ** Lifespan:**
            
            Digger bees typically live for a few weeks to several months, depending on the species and environmental conditions. Their life cycle includes foraging, nesting, and laying eggs before their adult phase ends.
            
            ** Diet:**
            
            Digger bees feed on nectar and pollen, which they collect for their offspring. Their nesting behavior helps in the pollination of a variety of plants.
            
            ** Sleep:** Digger bees rest in their burrows or in sheltered areas. They are diurnal and are active during the day.
            
            ** Allergies:**
            
            Digger bee stings are rare and generally mild. Allergic reactions can occur, ranging from minor irritation to more severe responses in sensitive individuals.
            
            ** Ecological Impact:**
            
            Digger bees play a crucial role in the pollination of many flowering plants. Their nesting behavior also contributes to soil health and the overall health of ecosystems.
            
            ** Conservation:**
            
            To support digger bees, preserve natural areas with suitable soils for nesting. Reducing pesticide use and planting a variety of flowering plants can also benefit these bees.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
        case .europeanHoneyBee:
            return """
            European honey bees (Apis mellifera) are a subspecies of honey bees known for their significant role in agriculture and honey production. They are managed globally for their ability to pollinate crops and produce honey. European honey bees are highly social insects with complex hive structures and behavior.
            
            ** Lifespan:**
            
            Worker European honey bees generally live for about 5-7 weeks, while queens can live for several years. Their life cycle includes foraging, hive maintenance, and reproduction.
            
            ** Diet:**
            
            European honey bees feed on nectar and pollen. Nectar is converted into honey, which serves as a food source for the hive, while pollen provides protein for developing larvae.
            
            ** Sleep:**
            
            European honey bees rest in their hive, which provides shelter and protection. They are active during the day and rest at night or during adverse weather conditions.
            
            ** Allergies:**
            
            Stings from European honey bees can cause allergic reactions in sensitive individuals. Reactions can range from mild irritation to severe allergic responses, including anaphylaxis.
            
            ** Ecological Impact:**
            
            European honey bees are vital for the pollination of many crops and wild plants. Their role in agriculture supports food production and ecosystem health.
            
            ** Conservation:**
            
            To support European honey bees, provide diverse forage plants, avoid pesticides, and support beekeeping practices that ensure hive health and sustainability.
            
            ** Sources:**
            
            - [Bee Conservancy](
            https://thebeeconservancy.org/)
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            """
        case .blueOrchardBee:
            return """
            Blue orchard bees (Osmia lignaria) are solitary bees known for their striking blue color and their role as effective pollinators of fruit trees, particularly orchards. They are part of the Megachilidae family and are highly valued for their ability to enhance fruit production.
            
            ** Lifespan:** Blue orchard bees generally live for about 6-8 weeks, primarily during the spring. They emerge as adults, mate, and then lay eggs in pre-existing cavities or artificial nesting structures.
            
            ** Diet:**
            
            They feed on nectar and pollen, which they collect and store in their nesting cavities. Blue orchard bees are excellent pollinators due to their efficient foraging behavior and their tendency to visit multiple flowers of the same type during each foraging trip.
            
            ** Sleep:**
            
            Blue orchard bees rest in their nests or in sheltered areas. They are diurnal, meaning they are active during the day and rest at night.
            
            ** Allergies:**
            
            Stings from blue orchard bees are rare and generally mild. Allergic reactions can occur, but they are typically less severe compared to stings from other bee species. However, individuals with sensitivities to bee stings should still exercise caution.
            
            ** Ecological Impact:**
            
            Blue orchard bees are crucial for the pollination of fruit trees and other flowering plants. Their pollination services enhance fruit yields and support biodiversity in agricultural ecosystems.
            
            ** Conservation:**
            
            To support blue orchard bees, provide suitable nesting sites such as drilled wood blocks or bee hotels. Planting a variety of flowering plants that bloom in early spring can also provide essential forage for these bees.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
            
        case .other:
            return """
            The "other" category encompasses a diverse range of bee species with unique behaviors and characteristics that do not fall into the more commonly known categories. These bees may include rare or less-studied species that contribute to ecosystems in various ways.
            
            ** Lifespan:**
            
            Lifespan varies widely among different bee species, ranging from a few weeks to several months. Each species has its own life cycle, which typically includes stages of egg, larva, pupa, and adult.
            
            ** Diet:**
            
            Most bees in this category feed on nectar and pollen, though some may have specialized diets or feeding behaviors. Their diets support their role as pollinators and contribute to the health of their habitats.
            
            ** Sleep:**
            
            Sleep patterns vary by species. Some bees rest in nests, burrows, or sheltered areas, while others may have unique sleeping behaviors. Their activity levels and rest periods are adapted to their specific ecological niches.
            
            ** Allergies:**
            
            The sting reactions of bees in this category can vary widely. Some may cause mild irritation, while others may provoke more severe allergic reactions. Individuals with a history of severe reactions to bee stings should exercise caution when interacting with these bees.
            
            ** Ecological Impact:**
            
            Bees in the "other" category play diverse roles in their ecosystems. They contribute to pollination, plant reproduction, and the overall health of their environments. Understanding their specific contributions is crucial for biodiversity and conservation efforts.
            
            ** Conservation:**
            
            To support these diverse bee species, it is important to protect their habitats, reduce pesticide use, and promote plant diversity. Providing suitable nesting sites and fostering a variety of flowering plants can benefit a wide range of bee species.
            
            ** Sources:**
            
            - [Pollinator Partnership]
            (https://www.pollinator.org/)
            
            - [Xerces Society]
            (https://xerces.org/)
            
            - [Bee Conservancy]
            (https://thebeeconservancy.org/)
            """
            
        }
    }
    
}
